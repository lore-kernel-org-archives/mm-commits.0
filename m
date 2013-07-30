From: akpm@linux-foundation.org
Subject: + procfs-remove-extra-call-of-dir_emit_dots.patch added to -mm
 tree
Date: Tue, 30 Jul 2013 15:36:57 -0700
Message-ID: <51f84009.NgOznrat0gYkCxva%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab3G3Wg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, viro@zeniv.linux.org.uk, gorcunov@openvz.org, avagin@openvz.org

Subject: + procfs-remove-extra-call-of-dir_emit_dots.patch added to -mm tree
To: avagin@openvz.org,gorcunov@openvz.org,viro@zeniv.linux.org.uk,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:36:57 -0700


The patch titled
     Subject: procfs: remove extra call of dir_emit_dots
has been added to the -mm tree.  Its filename is
     procfs-remove-extra-call-of-dir_emit_dots.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-remove-extra-call-of-dir_emit_dots.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-remove-extra-call-of-dir_emit_dots.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

move-exit_task_namespaces-outside-of-exit_notify-fix.patch
procfs-remove-extra-call-of-dir_emit_dots.patch

