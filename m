From: akpm@linux-foundation.org
Subject: + vfs-attr-check-attr_size-in-ia_valid-not-ia_mode.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:49:54 -0700
Message-ID: <201006182249.o5IMnsVN027804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab0FRWuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: attr, check ATTR_SIZE in ia_valid not ia_mode
has been added to the -mm tree.  Its filename is
     vfs-attr-check-attr_size-in-ia_valid-not-ia_mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: attr, check ATTR_SIZE in ia_valid not ia_mode
From: Jiri Slaby <jslaby@suse.cz>

Fix a bug introduced by linux-next commit "check ATTR_SIZE contraints in
inode_change_ok" which added a size check, but checks the size even if
ATTR_SIZE is not in attr->ia_valid because it tests the bit in
attr->ia_mode.

Test properly against ia_valid.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/attr.c~vfs-attr-check-attr_size-in-ia_valid-not-ia_mode fs/attr.c
--- a/fs/attr.c~vfs-attr-check-attr_size-in-ia_valid-not-ia_mode
+++ a/fs/attr.c
@@ -34,7 +34,7 @@ int inode_change_ok(const struct inode *
 	 * First check size constraints.  These can't be overriden using
 	 * ATTR_FORCE.
 	 */
-	if (attr->ia_mode & ATTR_SIZE) {
+	if (ia_valid & ATTR_SIZE) {
 		int error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
_

Patches currently in -mm which might be from jslaby@suse.cz are

cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic.patch
vfs-attr-check-attr_size-in-ia_valid-not-ia_mode.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch

