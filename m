From: akpm@linux-foundation.org
Subject: + unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:17:12 -0800
Message-ID: <200711090417.lA94HDfh028881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKIERX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@gmail.com, greg@kroah.com


The patch titled
     unbork gregkh-driver-kset-convert-sys-devices-to-use-kset_create (vio.c)
has been added to the -mm tree.  Its filename is
     unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unbork gregkh-driver-kset-convert-sys-devices-to-use-kset_create (vio.c)
From: Badari Pulavarty <pbadari@gmail.com>

On Tue, 2007-11-06 at 02:33 -0800, akpm@linux-foundation.org wrote:
> The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
>

> gregkh-driver-kset-convert-sys-devices-to-use-kset_create.patch

Above patch renamed devices_subsys to devices_kset to catch all users of
the variable. Need fixes to vio.

# make -j8 zImage
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1389:2: warning: #warning syscall revokeat not implemented
<stdin>:1393:2: warning: #warning syscall frevoke not implemented
  CHK     include/linux/compile.h
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o(.toc+0x1548): undefined reference to
`devices_subsys'
make: *** [.tmp_vmlinux1] Error 1

Here is the patch, Is this correct usage ?

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/vio.c~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc
+++ a/arch/powerpc/kernel/vio.c
@@ -37,7 +37,7 @@
 #include <asm/iseries/hv_call_xm.h>
 #include <asm/iseries/iommu.h>
 
-extern struct kset devices_subsys; /* needed for vio_find_name() */
+extern struct kset *devices_kset;  /* needed for vio_find_name() */
 
 static struct bus_type vio_bus_type;
 
@@ -369,7 +369,7 @@ static struct vio_dev *vio_find_name(con
 {
 	struct kobject *found;
 
-	found = kset_find_obj(&devices_subsys, kobj_name);
+	found = kset_find_obj(devices_kset, kobj_name);
 	if (!found)
 		return NULL;
 
_

Patches currently in -mm which might be from pbadari@gmail.com are

unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
mem-controller-gfp-mask-fix.patch
