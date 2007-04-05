From: akpm@linux-foundation.org
Subject: - slab-mention-slab-name-when-listing-corrupt-objects.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:49 -0700
Message-ID: <200704050200.l3520nCq004850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38075 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511AbXDECA6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     slab: mention slab name when listing corrupt objects
has been removed from the -mm tree.  Its filename was
     slab-mention-slab-name-when-listing-corrupt-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: mention slab name when listing corrupt objects
From: David Howells <dhowells@redhat.com>

Mention the slab name when listing corrupt objects.  Although the function
that released the memory is mentioned, that is frequently ambiguous as such
functions often release several pieces of memory.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-mention-slab-name-when-listing-corrupt-objects mm/slab.c
--- a/mm/slab.c~slab-mention-slab-name-when-listing-corrupt-objects
+++ a/mm/slab.c
@@ -1830,8 +1830,8 @@ static void check_poison_obj(struct kmem
 			/* Print header */
 			if (lines == 0) {
 				printk(KERN_ERR
-					"Slab corruption: start=%p, len=%d\n",
-					realobj, size);
+					"Slab corruption: %s start=%p, len=%d\n",
+					cachep->name, realobj, size);
 				print_objinfo(cachep, objp, 0);
 			}
 			/* Hexdump the affected line */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
mutex-subsystem-synchro-test-module.patch
