From: akpm@linux-foundation.org
Subject: - trace-add-missing-mutex_unlock.patch removed from -mm tree
Date: Tue, 25 Nov 2008 13:50:08 -0800
Message-ID: <200811252150.mAPLo8od024465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYKYVvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 16:51:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     trace: add missing mutex_unlock()
has been removed from the -mm tree.  Its filename was
     trace-add-missing-mutex_unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: trace: add missing mutex_unlock()


This error was spotted by this semantic patch:

http://www.emn.fr/x-info/coccinelle/mut.html

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/trace/ring_buffer.c~trace-add-missing-mutex_unlock kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~trace-add-missing-mutex_unlock
+++ a/kernel/trace/ring_buffer.c
@@ -652,6 +652,7 @@ int ring_buffer_resize(struct ring_buffe
 		list_del_init(&page->list);
 		free_buffer_page(page);
 	}
+	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

linux-next.patch
drm-fix-leak-of-uninitialized-data-to-userspace-2.patch
trace-add-missing-mutex_unlock.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
inotify-fix-type-errors-in-interfaces.patch

