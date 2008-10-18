From: akpm@linux-foundation.org
Subject: - w1-document-add-remove-search_count-and-pullup.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:56 -0700
Message-ID: <200810182319.m9INJuUi029596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbYJRXUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: Document add, remove, search_count, and pullup.
has been removed from the -mm tree.  Its filename was
     w1-document-add-remove-search_count-and-pullup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: Document add, remove, search_count, and pullup.
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

origin.patch

