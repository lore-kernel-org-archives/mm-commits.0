From: akpm@linux-foundation.org
Subject: + linux-next-revert-input-expand-keycode-space.patch added to -mm tree
Date: Thu, 31 Jul 2008 12:37:09 -0700
Message-ID: <200807311937.m6VJbAUj008029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYGaThv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 15:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     linux-next: revert "Input: expand keycode space"
has been added to the -mm tree.  Its filename is
     linux-next-revert-input-expand-keycode-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next: revert "Input: expand keycode space"
From: Hugh Dickins <hugh@veritas.com>

If you want to test 2.6.27-rc1-mm1, but your Synaptics pad is making X
crash immediately, and like Aunt Tillie and me you're more comfortable
patching your kernel than messing around in your userspace,
then reverting back from 768 to 512 keys should help.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h           |    2 +-
 include/linux/mod_devicetable.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/input.h~linux-next-revert-input-expand-keycode-space include/linux/input.h
--- a/include/linux/input.h~linux-next-revert-input-expand-keycode-space
+++ a/include/linux/input.h
@@ -592,7 +592,7 @@ struct input_absinfo {
 
 /* We avoid low common keys in module aliases so they don't get huge. */
 #define KEY_MIN_INTERESTING	KEY_MUTE
-#define KEY_MAX			0x2ff
+#define KEY_MAX			0x1ff
 #define KEY_CNT			(KEY_MAX+1)
 
 /*
diff -puN include/linux/mod_devicetable.h~linux-next-revert-input-expand-keycode-space include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~linux-next-revert-input-expand-keycode-space
+++ a/include/linux/mod_devicetable.h
@@ -274,7 +274,7 @@ struct pcmcia_device_id {
 /* Input */
 #define INPUT_DEVICE_ID_EV_MAX		0x1f
 #define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
-#define INPUT_DEVICE_ID_KEY_MAX		0x2ff
+#define INPUT_DEVICE_ID_KEY_MAX		0x1ff
 #define INPUT_DEVICE_ID_REL_MAX		0x0f
 #define INPUT_DEVICE_ID_ABS_MAX		0x3f
 #define INPUT_DEVICE_ID_MSC_MAX		0x07
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next-revert-input-expand-keycode-space.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
prio_tree-debugging-patch.patch

