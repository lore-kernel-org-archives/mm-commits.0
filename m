From: akpm@linux-foundation.org
Subject: - drm-fix-leak-of-uninitialized-data-to-userspace-2.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:28:57 -0800
Message-ID: <200812032028.mB3KSwZa028206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757186AbYLCU31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, airlied@linux.ie, sitsofe@yahoo.com, vegardno@thuin.ifi.uio.no, mm-commits@vger.kernel.org


The patch titled
     drm: fix leak of uninitialized data to userspace
has been removed from the -mm tree.  Its filename was
     drm-fix-leak-of-uninitialized-data-to-userspace-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: fix leak of uninitialized data to userspace
From: Vegard Nossum <vegard.nossum@gmail.com>

On Fri, Oct 10, 2008 at 10:54 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>
> [  175.375036] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f65d2294)
> [  175.375049] 7063693a303030303a30303a30322e3000a76c080800000000a76c080e000000
> [  175.375096]  i i i i i i i i i i i i i i i i i u u u u u u u u u u u u u u u
> [  175.375137]                                          ^
> [  175.375142]
> [  175.375148] Pid: 2288, comm: Xorg Not tainted (2.6.27-tipskw-00069-g37cb0b7-dirty #81) 900
> [  175.375155] EIP: 0060:[<c020d283>] EFLAGS: 00003246 CPU: 0
> [  175.375169] EIP is at __copy_to_user_ll+0x43/0x60
> [  175.375174] EAX: 00000000 EBX: 00000028 ECX: 00000005 EDX: f65d2280
> [  175.375180] ESI: f65d2294 EDI: 086cb6b4 EBP: f631bef4 ESP: c055bd68
> [  175.375186]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  175.375191] CR0: 8005003b CR2: f67c1c44 CR3: 36368000 CR4: 000006c0
> [  175.375197] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  175.375202] DR6: ffff4ff0 DR7: 00000400
> [  175.375206]  [<c020d6f3>] copy_to_user+0x43/0x60
> [  175.375214]  [<c028df28>] drm_getunique+0x38/0x50
> [  175.375224]  [<c028d329>] drm_ioctl+0x1b9/0x2f0
> [  175.375231]  [<c0188a07>] vfs_ioctl+0x67/0x70
> [  175.375239]  [<c0188a6c>] do_vfs_ioctl+0x5c/0x270
> [  175.375246]  [<c0188cbe>] sys_ioctl+0x3e/0x60
> [  175.375253]  [<c010336d>] sysenter_do_call+0x12/0x35
> [  175.375261]  [<ffffffff>] 0xffffffff

The hexdump decodes to:

vegardno@thuin ~ $ ./a.out 7063693a303030303a30303a30322e3000a76c080800000000a76c080e000000
pci:0000:00:02.0<0><167>l<8><8><0><0><0><0><167>l<8><14><0><0><0>

...so drm_getunique() is trying to copy some uninitialized data to
userspace. The ECX register contains the number of words that are
left to copy -- so there are 5 * 4 = 20 bytes left. The offset of the
first uninitialized byte (counting from the start of the string) is
also 20 (i.e. 0xf65d2294&((1 << 5)-1) == 20). So somebody tried to
copy 40 bytes when the string was only 19 long.

In drm_set_busid() we have this code:

        dev->unique_len = 40;
        dev->unique = drm_alloc(dev->unique_len + 1, DRM_MEM_DRIVER);
	...
        len = snprintf(dev->unique, dev->unique_len, "pci:%04x:%02x:%02x.%d",

...so it seems that dev->unique is never updated to reflect the
actual length of the string. The remaining bytes (20 in this case)
are random uninitialized bytes that are copied into userspace.

This patch fixes the problem by setting dev->unique_len after the
snprintf().

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Vegard Nossum <vegardno@thuin.ifi.uio.no>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/drm_ioctl.c~drm-fix-leak-of-uninitialized-data-to-userspace-2 drivers/gpu/drm/drm_ioctl.c
--- a/drivers/gpu/drm/drm_ioctl.c~drm-fix-leak-of-uninitialized-data-to-userspace-2
+++ a/drivers/gpu/drm/drm_ioctl.c
@@ -136,7 +136,7 @@ static int drm_set_busid(struct drm_devi
 		return -EBUSY;
 
 	master->unique_len = 40;
-	master->unique = drm_alloc(master->unique_len + 1, DRM_MEM_DRIVER);
+	master->unique = drm_alloc(master->unique_len, DRM_MEM_DRIVER);
 	if (master->unique == NULL)
 		return -ENOMEM;
 
@@ -145,8 +145,10 @@ static int drm_set_busid(struct drm_devi
 		       dev->pdev->bus->number,
 		       PCI_SLOT(dev->pdev->devfn),
 		       PCI_FUNC(dev->pdev->devfn));
-	if (len > master->unique_len)
+	if (len >= master->unique_len)
 		DRM_ERROR("buffer overflow");
+	else
+		master->unique_len = len;
 
 	dev->devname =
 	    drm_alloc(strlen(dev->driver->pci_driver.name) + master->unique_len +
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

linux-next.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
inotify-fix-type-errors-in-interfaces.patch

