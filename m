From: akpm@linux-foundation.org
Subject: [merged] procfs-remove-extra-call-of-dir_emit_dots.patch removed
 from -mm tree
Date: Mon, 26 Aug 2013 13:08:08 -0700
Message-ID: <521bb5a8.LRx/ioHYVO2HiZKi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab3HZUIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 16:08:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, viro@zeniv.linux.org.uk, gorcunov@openvz.org, avagin@openvz.org

Subject: [merged] procfs-remove-extra-call-of-dir_emit_dots.patch removed from -mm tree
To: avagin@openvz.org,gorcunov@openvz.org,viro@zeniv.linux.org.uk,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 13:08:08 -0700


The patch titled
     Subject: procfs: remove extra call of dir_emit_dots
has been removed from the -mm tree.  Its filename was
     procfs-remove-extra-call-of-dir_emit_dots.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: procfs: remove extra call of dir_emit_dots

dir_emit_dots() is called twice. Looks like a typo.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/fd.c~procfs-remove-extra-call-of-dir_emit_dots fs/proc/fd.c
--- a/fs/proc/fd.c~procfs-remove-extra-call-of-dir_emit_dots
+++ a/fs/proc/fd.c
@@ -230,8 +230,6 @@ static int proc_readfd_common(struct fil
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
-	if (!dir_emit_dots(file, ctx))
-		goto out;
 	files = get_files_struct(p);
 	if (!files)
 		goto out;
_

Patches currently in -mm which might be from avagin@openvz.org are

linux-next.patch
kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

