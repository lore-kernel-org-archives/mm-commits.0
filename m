From: akpm@linux-foundation.org
Subject: [merged] uhid-check-write-bitness-using-in_compat_syscall.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:59 -0700
Message-ID: <56f2d52b.reFthBSN5mUIXZGu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbcCWRlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, dh.herrmann@googlemail.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hid/uhid.c: check write() bitness using in_compat_syscall
has been removed from the -mm tree.  Its filename was
     uhid-check-write-bitness-using-in_compat_syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: drivers/hid/uhid.c: check write() bitness using in_compat_syscall

uhid changes the format expected in write() depending on bitness.
It should check the syscall bitness directly.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: David Herrmann <dh.herrmann@googlemail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/uhid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/uhid.c~uhid-check-write-bitness-using-in_compat_syscall drivers/hid/uhid.c
--- a/drivers/hid/uhid.c~uhid-check-write-bitness-using-in_compat_syscall
+++ a/drivers/hid/uhid.c
@@ -384,7 +384,7 @@ struct uhid_create_req_compat {
 static int uhid_event_from_user(const char __user *buffer, size_t len,
 				struct uhid_event *event)
 {
-	if (is_compat_task()) {
+	if (in_compat_syscall()) {
 		u32 type;
 
 		if (get_user(type, buffer))
_

Patches currently in -mm which might be from luto@kernel.org are


