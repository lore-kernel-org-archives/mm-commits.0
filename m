From: akpm@linux-foundation.org
Subject: + viafb-add-documentation-for-proc-interface.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:25 -0700
Message-ID: <201009212237.o8LMbPla006819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab0IUWlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: add documentation for proc interface
has been added to the -mm tree.  Its filename is
     viafb-add-documentation-for-proc-interface.patch

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
Subject: viafb: add documentation for proc interface
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Add documentation for the new proc interface that allows modification of
the output device configuration.  Should be stable and useful enough now
for daily use.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/viafb.txt |   48 +++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff -puN Documentation/fb/viafb.txt~viafb-add-documentation-for-proc-interface Documentation/fb/viafb.txt
--- a/Documentation/fb/viafb.txt~viafb-add-documentation-for-proc-interface
+++ a/Documentation/fb/viafb.txt
@@ -197,6 +197,54 @@ Notes:
        example,
            # fbset -depth 16
 
+
+[Configure viafb via /proc]
+---------------------------
+    The following files exist in /proc/viafb
+
+    supported_output_devices
+
+        This read-only file contains a full ',' seperated list containing all
+        output devices that could be available on your platform. It is likely
+        that not all of those have a connector on your hardware but it should
+        provide a good starting point to figure out which of those names match
+        a real connector.
+        Example:
+        # cat /proc/viafb/supported_output_devices
+
+    iga1/output_devices
+    iga2/output_devices
+
+        These two files are readable and writable. iga1 and iga2 are the two
+        independent units that produce the screen image. Those images can be
+        forwarded to one or more output devices. Reading those files is a way
+        to query which output devices are currently used by an iga.
+        Example:
+        # cat /proc/viafb/iga1/output_devices
+        If there are no output devices printed the output of this iga is lost.
+        This can happen for example if only one (the other) iga is used.
+        Writing to these files allows adjusting the output devices during
+        runtime. One can add new devices, remove existing ones or switch
+        between igas. Essentially you can write a ',' seperated list of device
+        names (or a single one) in the same format as the output to those
+        files. You can add a '+' or '-' as a prefix allowing simple addition
+        and removal of devices. So a prefix '+' adds the devices from your list
+        to the already existing ones, '-' removes the listed devices from the
+        existing ones and if no prefix is given it replaces all existing ones
+        with the listed ones. If you remove devices they are expected to turn
+        off. If you add devices that are already part of the other iga they are
+        removed there and added to the new one.
+        Examples:
+        Add CRT as output device to iga1
+        # echo +CRT > /proc/viafb/iga1/output_devices
+
+        Remove (turn off) DVP1 and LVDS1 as output devices of iga2
+        # echo -DVP1,LVDS1 > /proc/viafb/iga2/output_devices
+
+        Replace all iga1 output devices by CRT
+        # echo CRT > /proc/viafb/iga1/output_devices
+
+
 [Bootup with viafb]:
 --------------------
     Add the following line to your grub.conf:
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

linux-next.patch
viafb-add-interface-for-output-device-configuration.patch
viafb-limit-lcd-code-impact.patch
viafb-introduce-per-output-device-power-management.patch
viafb-vt1636-cleanup.patch
viafb-fix-i2c_transfer-error-handling.patch
viafb-enable-i2c-for-crt.patch
viafb-reduce-i2c-timeout-and-delay.patch
viafb-add-function-to-change-sync-polarity-per-device.patch
viafb-set-sync-polarity-for-all-output-devices.patch
viafb-add-a-mapping-of-supported-output-devices.patch
viafb-rename-output-devices.patch
viafb-add-documentation-for-proc-interface.patch

