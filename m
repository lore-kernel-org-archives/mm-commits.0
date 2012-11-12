From: akpm@linux-foundation.org
Subject: [merged] fanotify-fix-missing-break.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:23 -0800
Message-ID: <20121112210924.BAB865C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:55758 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2KLVJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:26 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so429742wey.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, alan@linux.intel.com, anders.blomdell@control.lth.se, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: fix missing break
has been removed from the -mm tree.  Its filename was
     fanotify-fix-missing-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Paris <eparis@redhat.com>
Subject: fanotify: fix missing break

Anders Blomdell noted in 2010 that Fanotify lost events and provided a
test case.  Eric Paris confirmed it was a bug and posted a fix to the list

https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/RrJfTfyW2BE

but never applied it.  Repeated attempts over time to actually get him to
apply it have never had a reply from anyone who has raised it

So apply it anyway

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Eric Paris <eparis@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-fix-missing-break fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-fix-missing-break
+++ a/fs/notify/fanotify/fanotify.c
@@ -21,6 +21,7 @@ static bool should_merge(struct fsnotify
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		default:
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch

