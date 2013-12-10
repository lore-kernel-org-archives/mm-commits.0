From: akpm@linux-foundation.org
Subject: +
 x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch added
 to -mm tree
Date: Tue, 10 Dec 2013 15:23:30 -0800
Message-ID: <52a7a272.qU0hPy+iDxcT3neI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3LJXXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:23:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, toshi.kani@hp.com, tglx@linutronix.de, mjg59@srcf.ucam.org, mingo@elte.hu, matt@console-pimps.org, hpa@zytor.com, horms@verge.net.au, greg@kroah.com, ebiederm@xmission.com, bp@suse.de, James.Bottomley@HansenPartnership.com, dyoung@redhat.com

Subject: + x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch added to -mm tree
To: dyoung@redhat.com,James.Bottomley@HansenPartnership.com,bp@suse.de,ebiederm@xmission.com,greg@kroah.com,horms@verge.net.au,hpa@zytor.com,matt@console-pimps.org,mingo@elte.hu,mjg59@srcf.ucam.org,tglx@linutronix.de,toshi.kani@hp.com,vgoyal@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:23:30 -0800


The patch titled
     Subject: x86: kdebugfs do not use __va for getting setup_data virt addr
has been added to the -mm tree.  Its filename is
     x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: x86: kdebugfs do not use __va for getting setup_data virt addr

kdump kernel will use memmap=exactmap kernel cmdline, but __va does not
work in case memmap=exactmap, so let's always use ioremap_cache.

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kdebugfs.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff -puN arch/x86/kernel/kdebugfs.c~x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr arch/x86/kernel/kdebugfs.c
--- a/arch/x86/kernel/kdebugfs.c~x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr
+++ a/arch/x86/kernel/kdebugfs.c
@@ -33,7 +33,6 @@ static ssize_t setup_data_read(struct fi
 	struct setup_data_node *node = file->private_data;
 	unsigned long remain;
 	loff_t pos = *ppos;
-	struct page *pg;
 	void *p;
 	u64 pa;
 
@@ -47,18 +46,12 @@ static ssize_t setup_data_read(struct fi
 		count = node->len - pos;
 
 	pa = node->paddr + sizeof(struct setup_data) + pos;
-	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
-	if (PageHighMem(pg)) {
-		p = ioremap_cache(pa, count);
-		if (!p)
-			return -ENXIO;
-	} else
-		p = __va(pa);
+	p = ioremap_cache(pa, count);
+	if (!p)
+		return -ENXIO;
 
 	remain = copy_to_user(user_buf, p, count);
-
-	if (PageHighMem(pg))
-		iounmap(p);
+	iounmap(p);
 
 	if (remain)
 		return -EFAULT;
@@ -109,7 +102,6 @@ static int __init create_setup_data_node
 	struct setup_data *data;
 	int error;
 	struct dentry *d;
-	struct page *pg;
 	u64 pa_data;
 	int no = 0;
 
@@ -126,16 +118,12 @@ static int __init create_setup_data_node
 			goto err_dir;
 		}
 
-		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
-		if (PageHighMem(pg)) {
-			data = ioremap_cache(pa_data, sizeof(*data));
-			if (!data) {
-				kfree(node);
-				error = -ENXIO;
-				goto err_dir;
-			}
-		} else
-			data = __va(pa_data);
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data) {
+			kfree(node);
+			error = -ENXIO;
+			goto err_dir;
+		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -143,8 +131,7 @@ static int __init create_setup_data_node
 		error = create_setup_data_node(d, no, node);
 		pa_data = data->next;
 
-		if (PageHighMem(pg))
-			iounmap(data);
+		iounmap(data);
 		if (error)
 			goto err_dir;
 		no++;
_

Patches currently in -mm which might be from dyoung@redhat.com are

kexec-migrate-to-reboot-cpu.patch
x86-mm-sparse-warning-fix-for-early_memremap.patch
efi-use-early_memremap-and-early_memunmap.patch
efi-remove-unused-variables-in-__map_region.patch
efi-add-a-wrapper-function-efi_map_region_fixed.patch
efi-reserve-boot-service-fix.patch
efi-cleanup-efi_enter_virtual_mode-function.patch
efi-export-more-efi-table-variable-to-sysfs.patch
efi-export-efi-runtime-memory-mapping-to-sysfs.patch
efi-pass-kexec-necessary-efi-data-via-setup_data.patch
efi-only-print-saved-efi-runtime-maps-instead-of-all-memmap-ranges-for-kexec.patch
x86-add-xloadflags-bit-for-efi-runtime-support-on-kexec.patch
x86-export-x86-boot_params-to-sysfs.patch
x86-reserve-setup_data-ranges-late-after-parsing-memmap-cmdline.patch
x86-kdebugfs-do-not-use-__va-for-getting-setup_data-virt-addr.patch

