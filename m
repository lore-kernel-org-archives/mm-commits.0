From: akpm@linux-foundation.org
Subject: + fix-6-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch added to -mm tree
Date: Tue, 25 Sep 2007 22:06:16 -0700
Message-ID: <200709260506.l8Q56GOT021561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbXIZFGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 01:06:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: greg@kroah.com


The patch titled
     fix-the-sixth: gregkh-driver-kobject-remove-the-static-array-for-the-name
has been added to the -mm tree.  Its filename is
     fix-6-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-the-sixth: gregkh-driver-kobject-remove-the-static-array-for-the-name
From: Greg KH <greg@kroah.com>

On Wed, Sep 26, 2007 at 01:02:37AM +0200, Miklos Szeredi wrote:
> > On Wed, Sep 26, 2007 at 12:27:14AM +0200, Miklos Szeredi wrote:
> > > I get "BUG: failure at mm/slab.c:591/page_get_cache()!" in latest -mm
> > > when removing the fuse module.
> > >
> > > This patch titled "kobject: remove the static array for the name"
> > > looks like it's responsible.  Reverting it cures the problem.
> > >
> > > The root of the problem seems to be, that decl_subsys() initializes
> > > k_name with a string constant.  Then subsystem_unregister() will put
> > > the kobject, which will free the k_name.
> > >
> > > So, what's the right way to deal with this?
> >
> > How is the static kobject created by decl_subsys() getting it's release
> > function called when it is never really "released" as it is a static
> > kobject?
>
> Don't know.
>
> This is the stack trace I get:
>
> BUG: failure at mm/slab.c:591/page_get_cache()!
> Kernel panic - not syncing: BUG!

Ok, here's a patch that fixes this for me.  It should go on top of the
-mm tree.  Let me know of this works or not.

In the end, we need to dynamically allocate these subsystems to properly
fix this.  In looking through the tree, there really isn't that many of
them, so I'll try to knock that out later this week.

thanks,

greg k-h

---
 1 file changed, 4 insertions(+), 4 deletions(-)


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/kobject.c~fix-6-gregkh-driver-kobject-remove-the-static-array-for-the-name lib/kobject.c
--- a/lib/kobject.c~fix-6-gregkh-driver-kobject-remove-the-static-array-for-the-name
+++ a/lib/kobject.c
@@ -444,11 +444,11 @@ void kobject_cleanup(struct kobject * ko
 	struct kobject * parent = kobj->parent;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	kfree(kobj->k_name);
-	kobj->k_name = NULL;
-	if (t && t->release)
+	if (t && t->release) {
 		t->release(kobj);
-	else
+		kfree(kobj->k_name);
+		kobj->k_name = NULL;
+	} else
 		pr_debug("kobject '%s' does not have a release() function, "
 			"if this is not a directory kobject, it is broken "
 			"and must be fixed.\n",
_

Patches currently in -mm which might be from greg@kroah.com are

fix-oops-in-platform-uevent.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
fix-6-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
git-kbuild.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
wake-up-from-a-serial-port.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch
scsi-send-media-state-change-modification-events.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
usb-gadget-ether-prevent-oops-caused-by-error-interrupt-race.patch
fix-gregkh-usb-usb-flush-outstanding-urbs-when-suspending.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
make-sure-nobodys-leaking-resources.patch
workaround-for-a-pci-restoring-bug.patch
