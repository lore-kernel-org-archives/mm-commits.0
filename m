From: akpm@linux-foundation.org
Subject: [merged] drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch removed from -mm tree
Date: Tue, 29 Nov 2011 12:03:30 -0800
Message-ID: <201111292003.pATK3UeM023910@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43566 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1K2UDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2011 15:03:34 -0500
Received: by eeuu44 with SMTP id u44so65202eeu.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2011 12:03:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@chromium.org, airlied@redhat.com, hidave.darkstar@gmail.com, hughd@google.com, marcheu@chromium.org, msb@chromium.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: avoid switching to text console if there is no panic=
 timeout
has been removed from the -mm tree.  Its filename was
     drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.p=
atch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
@@ -255,6 +255,13 @@ bool drm_fb_helper_force_kernel_mode(voi
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

Patches currently in -mm which might be from hughd@chromium.org are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
