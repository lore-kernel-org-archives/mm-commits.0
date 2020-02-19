From: akpm@linux-foundation.org
Subject: + mm-add-mremap_dontunmap-to-mremap-v6.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 12:33:58 -0800
Message-ID: <20200219203358.9KEda%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUeA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 15:34:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org, sonnyrao@google.com, natechancellor@gmail.com, mst@redhat.com, minchan@kernel.org, luto@amacapital.net, kirill@shutemov.name, jsbarnes@google.com, joel@joelfernandes.org, fweimer@redhat.com, arnd@arndb.de, aarcange@redhat.com, bgeffon@google.com


The patch titled
     Subject: mm-add-mremap_dontunmap-to-mremap-v6
has been added to the -mm tree.  Its filename is
     mm-add-mremap_dontunmap-to-mremap-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-mremap_dontunmap-to-mre=
map-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-mremap_dontunmap-to-mre=
map-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Geffon <bgeffon@google.com>
Subject: mm-add-mremap_dontunmap-to-mremap-v6

- Code cleanup suggested by Kirill.
- Correct commit message to more accurately reflect the behavior.
- Clear VM_LOCKED and VM_LOCKEDONFAULT on the old vma.
        =C2=A0 =C2=A0
Link: http://lkml.kernel.org/r/20200218173221.237674-1-bgeffon@google.com
Signed-off-by: Brian Geffon <bgeffon@google.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Deacon <will@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Jesse Barnes <jsbarnes@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-add-mremap_dontunmap-to-mremap-v6
+++ a/mm/mremap.c
@@ -426,8 +426,13 @@ static unsigned long move_vma(struct vm_
 		 * for old_len, but we're now adding new_len - old_len locked
 		 * bytes to the new mapping.
 		 */
-		if (new_len > old_len)
+		if (vm_flags & VM_LOCKED && new_len > old_len) {
 			mm->locked_vm +=3D (new_len - old_len) >> PAGE_SHIFT;
+			*locked =3D true;
+		}
+
+		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
+		vma->vm_flags &=3D VM_LOCKED_CLEAR_MASK;
=20
 		goto out;
 	}
@@ -687,7 +692,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	if (down_write_killable(&current->mm->mmap_sem))
 		return -EINTR;
=20
-	if (flags & MREMAP_FIXED || flags & MREMAP_DONTUNMAP) {
+	if (flags & (MREMAP_FIXED | MREMAP_DONTUNMAP)) {
 		ret =3D mremap_to(addr, old_len, new_addr, new_len,
 				&locked, flags, &uf, &uf_unmap_early,
 				&uf_unmap);
_

Patches currently in -mm which might be from bgeffon@google.com are

mm-add-mremap_dontunmap-to-mremap.patch
mm-add-mremap_dontunmap-to-mremap-v6.patch
selftest-add-mremap_dontunmap-selftest.patch
