From: akpm@linux-foundation.org
Subject: + windfarm-init-sysfs-attributes.patch added to -mm tree
Date: Wed, 24 Feb 2010 11:57:41 -0800
Message-ID: <201002241957.o1OJvfea017037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757903Ab0BXT6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:58:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, benh@kernel.crashing.org


The patch titled
     windfarm: init sysfs attributes
has been added to the -mm tree.  Its filename is
     windfarm-init-sysfs-attributes.patch

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
Subject: windfarm: init sysfs attributes
From: Johannes Berg <johannes@sipsolutions.net>

This is required for lockdep.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/windfarm_core.c         |    1 +
 drivers/macintosh/windfarm_smu_controls.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/macintosh/windfarm_core.c~windfarm-init-sysfs-attributes drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~windfarm-init-sysfs-attributes
+++ a/drivers/macintosh/windfarm_core.c
@@ -321,6 +321,7 @@ int wf_register_sensor(struct wf_sensor 
 	kref_init(&new_sr->ref);
 	list_add(&new_sr->link, &wf_sensors);
 
+	sysfs_attr_init(&new_sr->attr.attr);
 	new_sr->attr.attr.name = new_sr->name;
 	new_sr->attr.attr.mode = 0444;
 	new_sr->attr.show = wf_show_sensor;
diff -puN drivers/macintosh/windfarm_smu_controls.c~windfarm-init-sysfs-attributes drivers/macintosh/windfarm_smu_controls.c
--- a/drivers/macintosh/windfarm_smu_controls.c~windfarm-init-sysfs-attributes
+++ a/drivers/macintosh/windfarm_smu_controls.c
@@ -173,6 +173,7 @@ static struct smu_fan_control *smu_fan_c
 
 	fct->fan_type = pwm_fan;
 	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
+	sysfs_attr_init(&fct->ctrl.attr.attr);
 
 	/* We use the name & location here the same way we do for SMU sensors,
 	 * see the comment in windfarm_smu_sensors.c. The locations are a bit
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
linux-next.patch
windfarm-init-sysfs-attributes.patch
module-init-sysfs-attributes.patch

