Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F5B18873F;
	Fri, 15 Nov 2024 06:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653055; cv=none; b=El3ND1SB2KacQZR5V+ypNFwWDFlghhmGwzL3+tMNRUgGg15By+bkk1km3MnNJrxZ6aPzP0KAvxHku1/MFQbXwkViWsvHLxW5Xdzq+II7KfzSPul/qXTxBPPzwWqE1P/gAe05JRYxBWCYG1lRaFRf/1hIds5yyJgrHm2keMHoj+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653055; c=relaxed/simple;
	bh=MDMVBv6U+iekpjP73RsOAYT9pUMJjMaODKp8zXNrNgA=;
	h=Date:To:From:Subject:Message-Id; b=LDkUePMUZu9RXR6L74a2aKoGGLv8zzp/OBT5jC8WWepwh03ERT8Cv3DwYtMqfRebn8q9wys1Yz2RN6f31cdaWyq3Vq5jJWB2UVSMUnEdZwxzp9QaVMfL15Gvvqcl+Cx8zgB2cBkuNexD37lvKdDMF4Px7d3fO6ot8IQlABvIstM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pKsyo9Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pKsyo9Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102D8C4CECF;
	Fri, 15 Nov 2024 06:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653054;
	bh=MDMVBv6U+iekpjP73RsOAYT9pUMJjMaODKp8zXNrNgA=;
	h=Date:To:From:Subject:From;
	b=pKsyo9Okhj3uTphSODTeHWffNcJ3Caxzwqo40wew1AeihHKQN2dBM0dyHRPz4L0/O
	 kv88Beg4xQR6qR1Co0GTrNZ7NAimwYOKwXiL8c8eFQ0bwen2Wk/ivst6bJSNG4NSkQ
	 P915A54gYCJzncUpetyFFcgCCsEBYnAKEjS+9+Vw=
Date: Thu, 14 Nov 2024 22:44:10 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,joel@joelfernandes.org,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-address-wraparound-in-move_page_tables.patch removed from -mm tree
Message-Id: <20241115064414.102D8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: fix address wraparound in move_page_tables()
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-address-wraparound-in-move_page_tables.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
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


