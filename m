From: akpm@linux-foundation.org
Subject: + w1-document-add-remove-search_count-and-pullup.patch added to -mm tree
Date: Tue, 29 Jul 2008 16:14:47 -0700
Message-ID: <200807292314.m6TNElYM027003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbYG2XQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 19:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     w1: Document add, remove, search_count, and pullup.
has been added to the -mm tree.  Its filename is
     w1-document-add-remove-search_count-and-pullup.patch

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
Subject: w1: Document add, remove, search_count, and pullup.
From: David Fries <david@fries.net>

Document w1_master_add, w1_master_remove, search_count, and pullup.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/w1.generic |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN Documentation/w1/w1.generic~w1-document-add-remove-search_count-and-pullup Documentation/w1/w1.generic
--- a/Documentation/w1/w1.generic~w1-document-add-remove-search_count-and-pullup
+++ a/Documentation/w1/w1.generic
@@ -79,10 +79,13 @@ w1 master sysfs interface
 <xx-xxxxxxxxxxxxx> - a directory for a found device. The format is family-serial
 bus                - (standard) symlink to the w1 bus
 driver             - (standard) symlink to the w1 driver
+w1_master_add      - Manually register a slave device
 w1_master_attempts - the number of times a search was attempted
 w1_master_max_slave_count
                    - the maximum slaves that may be attached to a master
 w1_master_name     - the name of the device (w1_bus_masterX)
+w1_master_pullup   - 5V strong pullup 0 enabled, 1 disabled
+w1_master_remove   - Manually remove a slave device
 w1_master_search   - the number of searches left to do, -1=continual (default)
 w1_master_slave_count
                    - the number of slaves found
@@ -90,7 +93,13 @@ w1_master_slaves   - the names of the sl
 w1_master_timeout  - the delay in seconds between searches
 
 If you have a w1 bus that never changes (you don't add or remove devices),
-you can set w1_master_search to a positive value to disable searches.
+you can set the module parameter search_count to a small positive number
+for an initially small number of bus searches.  Alternatively it could be
+set to zero, then manually add the slave device serial numbers by
+w1_master_add device file.  The w1_master_add and w1_master_remove files
+generally only make sense when searching is disabled, as a search will
+redetect manually removed devices that are present and timeout manually
+added devices that aren't on the bus.
 
 
 w1 slave sysfs interface
_

Patches currently in -mm which might be from david@fries.net are

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

