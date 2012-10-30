From: akpm@linux-foundation.org
Subject: + fanotify-fix-missing-break.patch added to -mm tree
Date: Tue, 30 Oct 2012 16:24:32 -0700
Message-ID: <20121030232433.2047020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:49885 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2J3XYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 19:24:35 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so52855wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 16:24:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, alan@linux.intel.com, anders.blomdell@control.lth.se, stable@vger.kernel.org


The patch titled
     Subject: fanotify: fix missing break
has been added to the -mm tree.  Its filename is
     fanotify-fix-missing-break.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fanotify-fix-missing-break.patch
linux-next.patch

