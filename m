From: akpm@linux-foundation.org
Subject: + fujitsu-laptop-make-needlessly-global-symbols-static.patch added to -mm tree
Date: Thu, 08 Jul 2010 12:48:54 -0700
Message-ID: <201007081948.o68Jmsbh025007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995Ab0GHTtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 15:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, jwoithe@physics.adelaide.edu.au, mjg@redhat.com


The patch titled
     fujitsu-laptop: make needlessly global symbols static
has been added to the -mm tree.  Its filename is
     fujitsu-laptop-make-needlessly-global-symbols-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fujitsu-laptop: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>

The following symbols are needlessly defined global:

logolamp_led
kblamps_led

This patch makes the symbols static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/fujitsu-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-make-needlessly-global-symbols-static drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~fujitsu-laptop-make-needlessly-global-symbols-static
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -182,7 +182,7 @@ static enum led_brightness logolamp_get(
 static void logolamp_set(struct led_classdev *cdev,
 			       enum led_brightness brightness);
 
-struct led_classdev logolamp_led = {
+static struct led_classdev logolamp_led = {
  .name = "fujitsu::logolamp",
  .brightness_get = logolamp_get,
  .brightness_set = logolamp_set
@@ -192,7 +192,7 @@ static enum led_brightness kblamps_get(s
 static void kblamps_set(struct led_classdev *cdev,
 			       enum led_brightness brightness);
 
-struct led_classdev kblamps_led = {
+static struct led_classdev kblamps_led = {
  .name = "fujitsu::kblamps",
  .brightness_get = kblamps_get,
  .brightness_set = kblamps_set
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
hp-wmi-return-enodev-if-bios-does-not-export-any-supported-hp-wmi-guid.patch
fujitsu-laptop-remove-unnecessary-input_free_device-calls.patch
compal-laptop-fujitsu-laptop-msi-laptop-make-dmi_check_cb-to-return-1-instead-of-0.patch
asus_acpi-fix-a-memory-leak-in-asus_hotk_get_info.patch
asus_acpi-fix-coding-style-to-improve-readability.patch
acerhdf-make-needlessly-global-symbols-static.patch
classmate-laptop-make-needlessly-global-symbols-static.patch
fujitsu-laptop-make-needlessly-global-symbols-static.patch
msi-laptop-make-struct-rfkill_ops-const.patch
asus-laptop-fix-incorrect-return-value-for-write_acpi_int_ret-if-handle-is-null.patch
asus-laptop-return-proper-error-for-store_ledd-if-write_acpi_int-fail.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch

