Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26FF1BDC3;
	Tue, 12 Nov 2024 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731370416; cv=none; b=lC6uz6i1UpXS8FWX+BdRcF3619alvHM4K+TxWkQFT/DjN3ZGwgo+FWyL2brnVrBjxGC8YjXH89/nwq/ki927YK7NbuI9COKFoZfyriDZ24WshxkerpaR1aFrwHVnVByDwW8iQ/2FDfVxyM6jBVE/8KFamLVfPK5V+mzTiVGHnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731370416; c=relaxed/simple;
	bh=+fI8cTrL/l1wq4mTewMmTeINOP+i2wxlCK1IyjtbyJo=;
	h=Date:To:From:Subject:Message-Id; b=SiNCd51Z31FmmKUchYVoy5WU2ETXPX8s4yayyzNgRXheahDmJKWBv6FWW2S3t3nyT1dX+m9uNlX/M7Icg6zAsax61HPEFjPmENc03hDlJw4vl1DdghEUpvbM4BYD5/EUpwTScjcGSPqHyLfJ51yGeSrIzAPqOGypGNl+Sbl62vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7tiubsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7tiubsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79ACAC4CECF;
	Tue, 12 Nov 2024 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731370414;
	bh=+fI8cTrL/l1wq4mTewMmTeINOP+i2wxlCK1IyjtbyJo=;
	h=Date:To:From:Subject:From;
	b=p7tiubshpfSlSzZ8vdeoU17IrfhfaxEExteaI524Jjgw7nfv9KoH3o4EPziLd3WON
	 XlR0RwCMjJh6E0h8Uy7b9V8AvT6v3GqvoU5rB7qNOYYP0SS9kSo1hsNyO5lhJ/m44w
	 y2aLnGldDd12oPaLGAp406yeaRupOPS1aRhazEGs=
Date: Mon, 11 Nov 2024 16:13:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,joel@joelfernandes.org,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-address-wraparound-in-move_page_tables.patch added to mm-hotfixes-unstable branch
Message-Id: <20241112001334.79ACAC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: fix address wraparound in move_page_tables()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-address-wraparound-in-move_page_tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-address-wraparound-in-move_page_tables.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/mremap: fix address wraparound in move_page_tables()
Date: Mon, 11 Nov 2024 20:34:30 +0100

On 32-bit platforms, it is possible for the expression `len + old_addr <
old_end` to be false-positive if `len + old_addr` wraps around. 
`old_addr` is the cursor in the old range up to which page table entries
have been moved; so if the operation succeeded, `old_addr` is the *end* of
the old region, and adding `len` to it can wrap.

The overflow causes mremap() to mistakenly believe that PTEs have been
copied; the consequence is that mremap() bails out, but doesn't move the
PTEs back before the new VMA is unmapped, causing anonymous pages in the
region to be lost.  So basically if userspace tries to mremap() a
private-anon region and hits this bug, mremap() will return an error and
the private-anon region's contents appear to have been zeroed.

The idea of this check is that `old_end - len` is the original start
address, and writing the check that way also makes it easier to read; so
fix the check by rearranging the comparison accordingly.

(An alternate fix would be to refactor this function by introducing an
"orig_old_start" variable or such.)


Tested in a VM with a 32-bit X86 kernel; without the patch:

```
user@horn:~/big_mremap$ cat test.c
#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <err.h>
#include <sys/mman.h>

#define ADDR1 ((void*)0x60000000)
#define ADDR2 ((void*)0x10000000)
#define SIZE          0x50000000uL

int main(void) {
  unsigned char *p1 = mmap(ADDR1, SIZE, PROT_READ|PROT_WRITE,
      MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED_NOREPLACE, -1, 0);
  if (p1 == MAP_FAILED)
    err(1, "mmap 1");
  unsigned char *p2 = mmap(ADDR2, SIZE, PROT_NONE,
      MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED_NOREPLACE, -1, 0);
  if (p2 == MAP_FAILED)
    err(1, "mmap 2");
  *p1 = 0x41;
  printf("first char is 0x%02hhx\n", *p1);
  unsigned char *p3 = mremap(p1, SIZE, SIZE,
      MREMAP_MAYMOVE|MREMAP_FIXED, p2);
  if (p3 == MAP_FAILED) {
    printf("mremap() failed; first char is 0x%02hhx\n", *p1);
  } else {
    printf("mremap() succeeded; first char is 0x%02hhx\n", *p3);
  }
}
user@horn:~/big_mremap$ gcc -static -o test test.c
user@horn:~/big_mremap$ setarch -R ./test
first char is 0x41
mremap() failed; first char is 0x00
```

With the patch:

```
user@horn:~/big_mremap$ setarch -R ./test
first char is 0x41
mremap() succeeded; first char is 0x41
```

Link: https://lkml.kernel.org/r/20241111-fix-mremap-32bit-wrap-v1-1-61d6be73b722@google.com
Fixes: af8ca1c14906 ("mm/mremap: optimize the start addresses in move_page_tables()")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-address-wraparound-in-move_page_tables
+++ a/mm/mremap.c
@@ -648,7 +648,7 @@ again:
 	 * Prevent negative return values when {old,new}_addr was realigned
 	 * but we broke out of the above loop for the first PMD itself.
 	 */
-	if (len + old_addr < old_end)
+	if (old_addr < old_end - len)
 		return 0;
 
 	return len + old_addr - old_end;	/* how much done */
_

Patches currently in -mm which might be from jannh@google.com are

mm-mremap-fix-address-wraparound-in-move_page_tables.patch

