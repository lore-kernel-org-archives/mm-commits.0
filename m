Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA98642A8B
	for <mm-commits@vger.kernel.org>; Wed, 30 Oct 2024 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251763; cv=none; b=P/FuiDPPIeJvelq7d8tFtElqQoo+6iLKktomWX5e8GSX1DiyyuZBesYi0wpRgNgEgR9m4PujHCQNqvu3MMLI/tCYGptuj79A3uNE3+Bwe/dTUf/1fK/Stf0TBY3PqWXP2EN/ju2wKoOjwKxeJWAgf+9qmA398fFcymiZQZGl3GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251763; c=relaxed/simple;
	bh=534SWjwo00Y4AsXC+ODB/TbJ8GsanCXTaribBqc1WD0=;
	h=Date:To:From:Subject:Message-Id; b=sIFgTN+y/6DnkXIDH2mfphXco/ZHJekLZfHuvA/ZR8Nf+dA4a1qRwgrkqkyyq7Xe4w5vGFdQXfQBMHIArUhcUaWZXJy8LQcVh4Mnln9bkZySuFiS+M4SK9SI82EZ+GQNdTqqKE5urJNCy9G9ZiDWGl7wndrT7v1dAKXEO37PlW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=inPUmW4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="inPUmW4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE37C4CECD;
	Wed, 30 Oct 2024 01:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730251763;
	bh=534SWjwo00Y4AsXC+ODB/TbJ8GsanCXTaribBqc1WD0=;
	h=Date:To:From:Subject:From;
	b=inPUmW4URtnEmvMBR13VzSMs24xWr0cAzQxBdK2kScklnOuw3ZGkHVE9UuHXJDR7l
	 khR4U1xHnHA4wbrXl+HgnwUGIOo67AF6pm5+8Tat/nqLehArlqOsMD0Uh6ORaWlfjM
	 32vvuKgZqKxALCbxf+3bA5J4dRki4t5wM1HHxmyM=
Date: Tue, 29 Oct 2024 18:29:23 -0700
To: mm-commits@vger.kernel.org,yanzhen@vivo.com,yang.lee@linux.alibaba.com,rppt@kernel.org,osalvador@suse.de,jakobkoschel@gmail.com,h.j.bos@vu.nl,hbathini@linux.ibm.com,david@redhat.com,c.giuffrida@vu.nl,bjohannesmeyer@gmail.com,bhe@redhat.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,adobriyan@gmail.com,mtodorovac69@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch added to mm-nonmm-unstable branch
Message-Id: <20241030012923.8EE37C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/kcore.c: fix coccinelle reported ERROR instances
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: fs/proc/kcore.c: fix coccinelle reported ERROR instances
Date: Tue, 29 Oct 2024 06:46:52 +0100

Coccinelle complains about the nested reuse of the pointer `iter' with
different pointer type:

./fs/proc/kcore.c:515:26-30: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:534:23-27: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:550:40-44: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:568:27-31: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:581:28-32: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:599:27-31: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:607:38-42: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:614:26-30: ERROR: invalid reference to the index variable of the iterator on line 499

Replacing `struct kcore_list *iter' with `struct kcore_list *tmp' doesn't change the
scope and the functionality is the same and coccinelle seems happy.

NOTE: There was an issue with using `struct kcore_list *pos' as the nested iterator.
      The build did not work!

Link: https://lkml.kernel.org/r/20241029054651.86356-2-mtodorovac69@gmail.com
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20220331223700.902556-1-jakobkoschel@gmail.com
Fixes: 04d168c6d42d1 ("fs/proc/kcore.c: remove check of list iterator against head past the loop body")
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Yan Zhen <yanzhen@vivo.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcorec-fix-coccinelle-reported-error-instances
+++ a/fs/proc/kcore.c
@@ -493,13 +493,13 @@ static ssize_t read_kcore_iter(struct ki
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			struct kcore_list *iter;
+			struct kcore_list *tmp;
 
 			m = NULL;
-			list_for_each_entry(iter, &kclist_head, list) {
-				if (start >= iter->addr &&
-				    start < iter->addr + iter->size) {
-					m = iter;
+			list_for_each_entry(tmp, &kclist_head, list) {
+				if (start >= tmp->addr &&
+				    start < tmp->addr + tmp->size) {
+					m = tmp;
 					break;
 				}
 			}
_

Patches currently in -mm which might be from mtodorovac69@gmail.com are

fs-proc-kcorec-fix-coccinelle-reported-error-instances.patch

