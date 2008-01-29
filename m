From: akpm@linux-foundation.org
Subject: - x86-reboot-remove-inb_p-usage.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:12 -0800
Message-ID: <200801290150.m0T1oCv1027556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672AbYA2CA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 21:00:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, ak@suse.de, alan@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 reboot: Remove inb_p usage
has been removed from the -mm tree.  Its filename was
     x86-reboot-remove-inb_p-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 reboot: Remove inb_p usage
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We are driving a motherboard port so use a 2uS explicit delay at this
point.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/reboot.c~x86-reboot-remove-inb_p-usage arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-reboot-remove-inb_p-usage
+++ a/arch/x86/kernel/reboot.c
@@ -319,9 +319,11 @@ static inline void kb_wait(void)
 {
 	int i;
 
-	for (i = 0; i < 0x10000; i++)
-		if ((inb_p(0x64) & 0x02) == 0)
+	for (i = 0; i < 0x10000; i++) {
+		if ((inb(0x64) & 0x02) == 0)
 			break;
+		udelay(2);
+	}
 }
 
 void machine_emergency_restart(void)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
keyspan-fix-oops.patch
git-arm.patch
pata_pdc202xx_old-fix-crashes-with-atapi.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
avoid-waking-up-closed-serial-ports-on-resume.patch
serial-avoid-stalling-suspend-if-serial-port-wont-drain.patch
serial-speed-setup-failure-reporting.patch
serial-coding-style.patch
sh-termios-ioctl-definitions.patch
git-watchdog.patch
git-x86.patch
geode-lists-are-subscriber-only.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
documentation-about-unaligned-memory-access.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline.patch
fix-ixany-and-restart-after-signal-eg-ctrl-c-in-n_tty-line-discipline-update.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
mxser-mxser_new-first-pass-over-termios-reporting-for-the.patch
char-mxser-ioctl-cleanup.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
