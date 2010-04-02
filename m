From: akpm@linux-foundation.org
Subject: + device_attributes-add-sysfs_attr_init-for-dynamic-attributes.patch added to -mm tree
Date: Fri, 02 Apr 2010 16:45:35 -0700
Message-ID: <201004022345.o32NjZCW011931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab0DBXqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 19:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, benh@kernel.crashing.org, ebiederm@xmission.com, grant.likely@secretlab.ca, gregkh@suse.de, isely@pobox.com, krzysztof.h1@wp.pl, len.brown@intel.com, mchehab@infradead.org, mjg@redhat.com, sujith.thomas@intel.com


The patch titled
     device_attributes: add sysfs_attr_init() for dynamic attributes
has been added to the -mm tree.  Its filename is
     device_attributes-add-sysfs_attr_init-for-dynamic-attributes.patch

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
Subject: device_attributes: add sysfs_attr_init() for dynamic attributes
From: Wolfram Sang <w.sang@pengutronix.de>

Made necessary by 6992f5334995af474c2b58d010d08bc597f0f2fe ("sysfs: Use
one lockdep class per sysfs attribute").

Prevents further "key xxx not in .data" bug-reports.  Although some
attributes could probably be converted to static ones, this is left for
people having hardware to test.

Found by this semantic patch:

@ init @
type T;
identifier A;
@@

        T {
                ...
                struct device_attribute A;
                ...
        };

@ main extends init @
expression E;
statement S;
identifier err;
T *name;
@@

        ... when != sysfs_attr_init(&name->A.attr);
(
+       sysfs_attr_init(&name->A.attr);
        if (device_create_file(E, &name->A))
                S
|
+       sysfs_attr_init(&name->A.attr);
        err = device_create_file(E, &name->A);
)

While reviewing, I put the initialization to apropriate places.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/windfarm_core.c           |    1 +
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c |    8 ++++++++
 drivers/platform/x86/intel_menlow.c         |    1 +
 drivers/video/fsl-diu-fb.c                  |    1 +
 4 files changed, 11 insertions(+)

diff -puN drivers/macintosh/windfarm_core.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes
+++ a/drivers/macintosh/windfarm_core.c
@@ -210,6 +210,7 @@ int wf_register_control(struct wf_contro
 	kref_init(&new_ct->ref);
 	list_add(&new_ct->link, &wf_controls);
 
+	sysfs_attr_init(&new_ct->attr.attr);
 	new_ct->attr.attr.name = new_ct->name;
 	new_ct->attr.attr.mode = 0644;
 	new_ct->attr.show = wf_show_control;
diff -puN drivers/media/video/pvrusb2/pvrusb2-sysfs.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes drivers/media/video/pvrusb2/pvrusb2-sysfs.c
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes
+++ a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -423,10 +423,12 @@ static void pvr2_sysfs_add_debugifc(stru
 
 	dip = kzalloc(sizeof(*dip),GFP_KERNEL);
 	if (!dip) return;
+	sysfs_attr_init(&dip->attr_debugcmd.attr);
 	dip->attr_debugcmd.attr.name = "debugcmd";
 	dip->attr_debugcmd.attr.mode = S_IRUGO|S_IWUSR|S_IWGRP;
 	dip->attr_debugcmd.show = debugcmd_show;
 	dip->attr_debugcmd.store = debugcmd_store;
+	sysfs_attr_init(&dip->attr_debuginfo.attr);
 	dip->attr_debuginfo.attr.name = "debuginfo";
 	dip->attr_debuginfo.attr.mode = S_IRUGO;
 	dip->attr_debuginfo.show = debuginfo_show;
@@ -644,6 +646,7 @@ static void class_dev_create(struct pvr2
 		return;
 	}
 
+	sysfs_attr_init(&sfp->attr_v4l_minor_number.attr);
 	sfp->attr_v4l_minor_number.attr.name = "v4l_minor_number";
 	sfp->attr_v4l_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_minor_number.show = v4l_minor_number_show;
@@ -658,6 +661,7 @@ static void class_dev_create(struct pvr2
 		sfp->v4l_minor_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_v4l_radio_minor_number.attr);
 	sfp->attr_v4l_radio_minor_number.attr.name = "v4l_radio_minor_number";
 	sfp->attr_v4l_radio_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_radio_minor_number.show = v4l_radio_minor_number_show;
@@ -672,6 +676,7 @@ static void class_dev_create(struct pvr2
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_unit_number.attr);
 	sfp->attr_unit_number.attr.name = "unit_number";
 	sfp->attr_unit_number.attr.mode = S_IRUGO;
 	sfp->attr_unit_number.show = unit_number_show;
@@ -685,6 +690,7 @@ static void class_dev_create(struct pvr2
 		sfp->unit_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_bus_info.attr);
 	sfp->attr_bus_info.attr.name = "bus_info_str";
 	sfp->attr_bus_info.attr.mode = S_IRUGO;
 	sfp->attr_bus_info.show = bus_info_show;
@@ -699,6 +705,7 @@ static void class_dev_create(struct pvr2
 		sfp->bus_info_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_hdw_name.attr);
 	sfp->attr_hdw_name.attr.name = "device_hardware_type";
 	sfp->attr_hdw_name.attr.mode = S_IRUGO;
 	sfp->attr_hdw_name.show = hdw_name_show;
@@ -713,6 +720,7 @@ static void class_dev_create(struct pvr2
 		sfp->hdw_name_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_hdw_desc.attr);
 	sfp->attr_hdw_desc.attr.name = "device_hardware_description";
 	sfp->attr_hdw_desc.attr.mode = S_IRUGO;
 	sfp->attr_hdw_desc.show = hdw_desc_show;
diff -puN drivers/platform/x86/intel_menlow.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes drivers/platform/x86/intel_menlow.c
--- a/drivers/platform/x86/intel_menlow.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes
+++ a/drivers/platform/x86/intel_menlow.c
@@ -397,6 +397,7 @@ static int intel_menlow_add_one_attribut
 	if (!attr)
 		return -ENOMEM;
 
+	sysfs_attr_init(&attr->attr.attr); /* That is consistent naming :D */
 	attr->attr.attr.name = name;
 	attr->attr.attr.mode = mode;
 	attr->attr.show = show;
diff -puN drivers/video/fsl-diu-fb.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~device_attributes-add-sysfs_attr_init-for-dynamic-attributes
+++ a/drivers/video/fsl-diu-fb.c
@@ -1536,6 +1536,7 @@ static int __devinit fsl_diu_probe(struc
 		goto error;
 	}
 
+	sysfs_attr_init(&machine_data->dev_attr.attr);
 	machine_data->dev_attr.attr.name = "monitor";
 	machine_data->dev_attr.attr.mode = S_IRUGO|S_IWUSR;
 	machine_data->dev_attr.show = show_monitor;
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
drivers-thermal-thermal_sysc-fix-key-f70f4b50-not-in-data-in-thermal_sys.patch
device_attributes-add-sysfs_attr_init-for-dynamic-attributes.patch
thermal-make-lockdep-happy.patch
firmware-loader-use-statically-initialized-data-attribute.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch

