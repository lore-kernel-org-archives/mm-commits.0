From: akpm@linux-foundation.org
Subject: + power_supply-remove-capacity_level-from-list-of-sysfs-attributes.patch added to -mm tree
Date: Wed, 06 Feb 2008 13:56:12 -0800
Message-ID: <200802062156.m16LuCJu032199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554AbYBFV5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 16:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@minaslivre.org, dilinger@debian.org, dilinger@queued.net, dwmw2@infradead.org, stable@kernel.org


The patch titled
     power_supply: remove capacity_level from list of sysfs attributes
has been added to the -mm tree.  Its filename is
     power_supply-remove-capacity_level-from-list-of-sysfs-attributes.patch

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
Subject: power_supply: remove capacity_level from list of sysfs attributes
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>

This commit:

commit 8efe444038a205e79b38b7ad03878824901849a8
Author: Andres Salomon <dilinger@queued.net>
Date:   Wed Dec 12 14:12:56 2007 -0500

    power: remove POWER_SUPPLY_PROP_CAPACITY_LEVEL

Removed CAPACITY_LEVEL from every other code, leaving the array with sysfs
attributes with one more entry than the number of enums in power_supply.h. 
This leads to some attributes containing the value of the attribute right
after it.  For example, temp_ambient would have the value of
time_to_empty_now.  In my case, I had time_to_full_avg have the value which
should be in model_name, when the former was usually empty.

Cc: Andres Salomon <dilinger@debian.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/power_supply_sysfs.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/power/power_supply_sysfs.c~power_supply-remove-capacity_level-from-list-of-sysfs-attributes drivers/power/power_supply_sysfs.c
--- a/drivers/power/power_supply_sysfs.c~power_supply-remove-capacity_level-from-list-of-sysfs-attributes
+++ a/drivers/power/power_supply_sysfs.c
@@ -106,7 +106,6 @@ static struct device_attribute power_sup
 	POWER_SUPPLY_ATTR(energy_now),
 	POWER_SUPPLY_ATTR(energy_avg),
 	POWER_SUPPLY_ATTR(capacity),
-	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
 	POWER_SUPPLY_ATTR(temp_ambient),
 	POWER_SUPPLY_ATTR(time_to_empty_now),
_

Patches currently in -mm which might be from cascardo@minaslivre.org are

power_supply-remove-capacity_level-from-list-of-sysfs-attributes.patch
