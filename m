From: akpm@linux-foundation.org
Subject: + drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch added to -mm tree
Date: Tue, 18 Oct 2011 15:42:46 -0700
Message-ID: <201110182242.p9IMgk0j016739@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5410 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1JRWm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 18:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@chromium.org, airlied@redhat.com, hidave.darkstar@gmail.com, hughd@google.com, marcheu@chromium.org, msb@chromium.org, rientjes@google.com


The patch titled
     Subject: drm: avoid switching to text console if there is no panic=
 timeout
has been added to the -mm tree.  Its filename is
     drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.p=
atch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Hugh Dickins <hughd@chromium.org>
Subject: drm: avoid switching to text console if there is no panic time=
out

Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
we're going to reboot immediately, the user will not be able to see the
messages anyway, and messing with the video mode may display artifacts,
and certainly get into several layers of complexity (including mutexes =
and
memory allocations) which we shall be much safer to avoid.

[msb@chromium.org: edited commit message and modified to short-circuit =
panic_timeout < 0 instead of testing panic_timeout >=3D 0]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Dave Airlie <airlied@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: St=E9phane Marchesin <marcheu@chromium.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_fb_helper.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/gpu/drm/drm_fb_helper.c~drm-avoid-switching-to-text-c=
onsole-if-there-is-no-panic-timeout drivers/gpu/drm/drm_fb_helper.c
--- a/drivers/gpu/drm/drm_fb_helper.c~drm-avoid-switching-to-text-conso=
le-if-there-is-no-panic-timeout
+++ a/drivers/gpu/drm/drm_fb_helper.c
@@ -256,6 +256,13 @@ bool drm_fb_helper_force_kernel_mode(voi
 int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununse=
d,
 			void *panic_str)
 {
+	/*
+	 * It's a waste of time and effort to switch back to text console
+	 * if the kernel should reboot before panic messages can be seen.
+	 */
+	if (panic_timeout < 0)
+		return 0;
+
 	printk(KERN_ERR "panic occurred, switching back to text console\n");
 	return drm_fb_helper_force_kernel_mode();
 }
_
Subject: Subject: drm: avoid switching to text console if there is no p=
anic timeout

Patches currently in -mm which might be from hughd@chromium.org are

drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
