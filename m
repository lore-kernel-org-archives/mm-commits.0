From: akpm@osdl.org
Subject: + mark-struct-file_operations-const-2.patch added to -mm tree
Date: Tue, 23 Jan 2007 11:31:59 -0800
Message-ID: <200701231931.l0NJVxZC028979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128AbXAWTcH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 14:32:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     mark struct file_operations const 2
has been added to the -mm tree.  Its filename is
     mark-struct-file_operations-const-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mark struct file_operations const 2
From: Arjan van de Ven <arjan@linux.intel.com>

Many struct file_operations in the kernel can be "const".  Marking them const
moves these to the .rodata section, which avoids false sharing with potential
dirty data.  In addition it'll catch accidental writes at compile time to
these shared resources.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/common/rtctime.c                    |    2 
 arch/arm/kernel/apm.c                        |    2 
 arch/arm/mach-at91rm9200/clock.c             |    2 
 arch/avr32/mm/tlb.c                          |    2 
 arch/cris/arch-v10/drivers/ds1302.c          |    2 
 arch/cris/arch-v10/drivers/eeprom.c          |    2 
 arch/cris/arch-v10/drivers/gpio.c            |    2 
 arch/cris/arch-v10/drivers/i2c.c             |    2 
 arch/cris/arch-v10/drivers/pcf8563.c         |    2 
 arch/cris/arch-v32/drivers/cryptocop.c       |    2 
 arch/cris/arch-v32/drivers/gpio.c            |    2 
 arch/cris/arch-v32/drivers/i2c.c             |    2 
 arch/cris/arch-v32/drivers/pcf8563.c         |    2 
 arch/cris/arch-v32/drivers/sync_serial.c     |    2 
 arch/cris/kernel/profile.c                   |    2 
 arch/i386/kernel/apm.c                       |    2 
 arch/i386/kernel/cpu/mtrr/if.c               |    2 
 arch/i386/kernel/cpuid.c                     |    2 
 arch/i386/kernel/microcode.c                 |    2 
 arch/i386/kernel/msr.c                       |    2 
 arch/ia64/hp/common/sba_iommu.c              |    2 
 arch/ia64/kernel/perfmon.c                   |    6 +-
 arch/ia64/kernel/salinfo.c                   |    4 -
 arch/ia64/sn/kernel/sn2/sn2_smp.c            |    2 
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    2 
 arch/m68k/bvme6000/rtc.c                     |    2 
 arch/m68k/mvme16x/rtc.c                      |    2 
 arch/mips/kernel/apm.c                       |    2 
 arch/mips/kernel/rtlx.c                      |    2 
 arch/mips/kernel/vpe.c                       |    2 
 arch/mips/sibyte/sb1250/bcm1250_tbprof.c     |    2 
 arch/parisc/kernel/perf.c                    |    2 
 arch/powerpc/kernel/lparcfg.c                |    2 
 arch/powerpc/kernel/nvram_64.c               |    2 
 arch/powerpc/kernel/proc_ppc64.c             |    2 
 arch/powerpc/kernel/rtas-proc.c              |   14 ++---
 arch/powerpc/kernel/rtas_flash.c             |    8 +--
 arch/powerpc/platforms/cell/spufs/file.c     |   40 ++++++++---------
 arch/powerpc/platforms/cell/spufs/inode.c    |    4 -
 arch/powerpc/platforms/iseries/lpevents.c    |    2 
 arch/powerpc/platforms/iseries/mf.c          |    2 
 arch/powerpc/platforms/iseries/proc.c        |    2 
 arch/powerpc/platforms/iseries/viopath.c     |    2 
 arch/powerpc/platforms/pseries/eeh.c         |    2 
 arch/powerpc/platforms/pseries/hvCall_inst.c |    2 
 arch/powerpc/platforms/pseries/reconfig.c    |    2 
 arch/powerpc/platforms/pseries/rtasd.c       |    2 
 arch/powerpc/platforms/pseries/scanlog.c     |    2 
 arch/ppc/8xx_io/cs4218_tdm.c                 |    6 +-
 arch/s390/hypfs/inode.c                      |    4 -
 arch/s390/kernel/debug.c                     |    2 
 arch/sh/boards/landisk/landisk_pwb.c         |    2 
 arch/sh/kernel/apm.c                         |    2 
 arch/sh/mm/cache-debugfs.c                   |    2 
 arch/sh/mm/pmb.c                             |    2 
 arch/sh/oprofile/op_model_sh7750.c           |    2 
 arch/sparc/kernel/apc.c                      |    2 
 arch/sparc64/kernel/time.c                   |    2 
 arch/sparc64/solaris/socksys.c               |    4 -
 arch/um/drivers/harddog_kern.c               |    2 
 arch/v850/kernel/rte_cb_leds.c               |    2 
 arch/x86_64/kernel/mce.c                     |    2 
 62 files changed, 98 insertions(+), 98 deletions(-)

diff -puN arch/arm/common/rtctime.c~mark-struct-file_operations-const-2 arch/arm/common/rtctime.c
--- a/arch/arm/common/rtctime.c~mark-struct-file_operations-const-2
+++ a/arch/arm/common/rtctime.c
@@ -329,7 +329,7 @@ static int rtc_fasync(int fd, struct fil
 	return fasync_helper(fd, file, on, &rtc_async_queue);
 }
 
-static struct file_operations rtc_fops = {
+static const struct file_operations rtc_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= rtc_read,
diff -puN arch/arm/kernel/apm.c~mark-struct-file_operations-const-2 arch/arm/kernel/apm.c
--- a/arch/arm/kernel/apm.c~mark-struct-file_operations-const-2
+++ a/arch/arm/kernel/apm.c
@@ -446,7 +446,7 @@ static int apm_open(struct inode * inode
 	return as ? 0 : -ENOMEM;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
diff -puN arch/arm/mach-at91rm9200/clock.c~mark-struct-file_operations-const-2 arch/arm/mach-at91rm9200/clock.c
--- a/arch/arm/mach-at91rm9200/clock.c~mark-struct-file_operations-const-2
+++ a/arch/arm/mach-at91rm9200/clock.c
@@ -407,7 +407,7 @@ static int at91_clk_open(struct inode *i
 	return single_open(file, at91_clk_show, NULL);
 }
 
-static struct file_operations at91_clk_operations = {
+static const struct file_operations at91_clk_operations = {
 	.open		= at91_clk_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/avr32/mm/tlb.c~mark-struct-file_operations-const-2 arch/avr32/mm/tlb.c
--- a/arch/avr32/mm/tlb.c~mark-struct-file_operations-const-2
+++ a/arch/avr32/mm/tlb.c
@@ -360,7 +360,7 @@ static int tlb_open(struct inode *inode,
 	return seq_open(file, &tlb_ops);
 }
 
-static struct file_operations proc_tlb_operations = {
+static const struct file_operations proc_tlb_operations = {
 	.open		= tlb_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/cris/arch-v10/drivers/ds1302.c~mark-struct-file_operations-const-2 arch/cris/arch-v10/drivers/ds1302.c
--- a/arch/cris/arch-v10/drivers/ds1302.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v10/drivers/ds1302.c
@@ -499,7 +499,7 @@ print_rtc_status(void)
 
 /* The various file operations we support. */
 
-static struct file_operations rtc_fops = {
+static const struct file_operations rtc_fops = {
 	.owner =	THIS_MODULE,
 	.ioctl =	rtc_ioctl,
 }; 
diff -puN arch/cris/arch-v10/drivers/eeprom.c~mark-struct-file_operations-const-2 arch/cris/arch-v10/drivers/eeprom.c
--- a/arch/cris/arch-v10/drivers/eeprom.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v10/drivers/eeprom.c
@@ -172,7 +172,7 @@ static const char eeprom_name[] = "eepro
 static struct eeprom_type eeprom;
 
 /* This is the exported file-operations structure for this device. */
-struct file_operations eeprom_fops =
+const struct file_operations eeprom_fops =
 {
   .llseek  = eeprom_lseek,
   .read    = eeprom_read,
diff -puN arch/cris/arch-v10/drivers/gpio.c~mark-struct-file_operations-const-2 arch/cris/arch-v10/drivers/gpio.c
--- a/arch/cris/arch-v10/drivers/gpio.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v10/drivers/gpio.c
@@ -838,7 +838,7 @@ gpio_leds_ioctl(unsigned int cmd, unsign
 	return 0;
 }
 
-struct file_operations gpio_fops = {
+const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
 	.ioctl       = gpio_ioctl,
diff -puN arch/cris/arch-v10/drivers/i2c.c~mark-struct-file_operations-const-2 arch/cris/arch-v10/drivers/i2c.c
--- a/arch/cris/arch-v10/drivers/i2c.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v10/drivers/i2c.c
@@ -692,7 +692,7 @@ i2c_ioctl(struct inode *inode, struct fi
 	return 0;
 }
 
-static struct file_operations i2c_fops = {
+static const struct file_operations i2c_fops = {
 	.owner    = THIS_MODULE,
 	.ioctl    = i2c_ioctl,
 	.open     = i2c_open,
diff -puN arch/cris/arch-v10/drivers/pcf8563.c~mark-struct-file_operations-const-2 arch/cris/arch-v10/drivers/pcf8563.c
--- a/arch/cris/arch-v10/drivers/pcf8563.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v10/drivers/pcf8563.c
@@ -56,7 +56,7 @@ static const unsigned char days_in_month
 
 int pcf8563_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
 
-static struct file_operations pcf8563_fops = {
+static const struct file_operations pcf8563_fops = {
 	.owner = THIS_MODULE,
 	.ioctl = pcf8563_ioctl,
 };
diff -puN arch/cris/arch-v32/drivers/cryptocop.c~mark-struct-file_operations-const-2 arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -266,7 +266,7 @@ static void print_user_dma_lists(struct 
 
 
 
-struct file_operations cryptocop_fops = {
+const struct file_operations cryptocop_fops = {
 	owner: THIS_MODULE,
 	open: cryptocop_open,
 	release: cryptocop_release,
diff -puN arch/cris/arch-v32/drivers/gpio.c~mark-struct-file_operations-const-2 arch/cris/arch-v32/drivers/gpio.c
--- a/arch/cris/arch-v32/drivers/gpio.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v32/drivers/gpio.c
@@ -705,7 +705,7 @@ gpio_leds_ioctl(unsigned int cmd, unsign
 	return 0;
 }
 
-struct file_operations gpio_fops = {
+const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
 	.ioctl       = gpio_ioctl,
diff -puN arch/cris/arch-v32/drivers/i2c.c~mark-struct-file_operations-const-2 arch/cris/arch-v32/drivers/i2c.c
--- a/arch/cris/arch-v32/drivers/i2c.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v32/drivers/i2c.c
@@ -573,7 +573,7 @@ i2c_ioctl(struct inode *inode, struct fi
 	return 0;
 }
 
-static struct file_operations i2c_fops = {
+static const struct file_operations i2c_fops = {
 	owner:    THIS_MODULE,
 	ioctl:    i2c_ioctl,
 	open:     i2c_open,
diff -puN arch/cris/arch-v32/drivers/pcf8563.c~mark-struct-file_operations-const-2 arch/cris/arch-v32/drivers/pcf8563.c
--- a/arch/cris/arch-v32/drivers/pcf8563.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v32/drivers/pcf8563.c
@@ -50,7 +50,7 @@ int pcf8563_ioctl(struct inode *, struct
 int pcf8563_open(struct inode *, struct file *);
 int pcf8563_release(struct inode *, struct file *);
 
-static struct file_operations pcf8563_fops = {
+static const struct file_operations pcf8563_fops = {
 	owner: THIS_MODULE,
 	ioctl: pcf8563_ioctl,
 	open: pcf8563_open,
diff -puN arch/cris/arch-v32/drivers/sync_serial.c~mark-struct-file_operations-const-2 arch/cris/arch-v32/drivers/sync_serial.c
--- a/arch/cris/arch-v32/drivers/sync_serial.c~mark-struct-file_operations-const-2
+++ a/arch/cris/arch-v32/drivers/sync_serial.c
@@ -187,7 +187,7 @@ static struct sync_port ports[]=
 
 #define NUMBER_OF_PORTS (sizeof(ports)/sizeof(sync_port))
 
-static struct file_operations sync_serial_fops = {
+static const struct file_operations sync_serial_fops = {
 	.owner   = THIS_MODULE,
 	.write   = sync_serial_write,
 	.read    = sync_serial_read,
diff -puN arch/cris/kernel/profile.c~mark-struct-file_operations-const-2 arch/cris/kernel/profile.c
--- a/arch/cris/kernel/profile.c~mark-struct-file_operations-const-2
+++ a/arch/cris/kernel/profile.c
@@ -50,7 +50,7 @@ write_cris_profile(struct file *file, co
   memset(sample_buffer, 0, SAMPLE_BUFFER_SIZE);
 }
 
-static struct file_operations cris_proc_profile_operations = {
+static const struct file_operations cris_proc_profile_operations = {
 	.read		= read_cris_profile,
 	.write		= write_cris_profile,
 };
diff -puN arch/i386/kernel/apm.c~mark-struct-file_operations-const-2 arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~mark-struct-file_operations-const-2
+++ a/arch/i386/kernel/apm.c
@@ -1860,7 +1860,7 @@ static int __init apm_setup(char *str)
 __setup("apm=", apm_setup);
 #endif
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= do_read,
 	.poll		= do_poll,
diff -puN arch/i386/kernel/cpu/mtrr/if.c~mark-struct-file_operations-const-2 arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~mark-struct-file_operations-const-2
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -369,7 +369,7 @@ static int mtrr_open(struct inode *inode
 	return single_open(file, mtrr_seq_show, NULL);
 }
 
-static struct file_operations mtrr_fops = {
+static const struct file_operations mtrr_fops = {
 	.owner   = THIS_MODULE,
 	.open	 = mtrr_open, 
 	.read    = seq_read,
diff -puN arch/i386/kernel/cpuid.c~mark-struct-file_operations-const-2 arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~mark-struct-file_operations-const-2
+++ a/arch/i386/kernel/cpuid.c
@@ -145,7 +145,7 @@ static int cpuid_open(struct inode *inod
 /*
  * File operations we support
  */
-static struct file_operations cpuid_fops = {
+static const struct file_operations cpuid_fops = {
 	.owner = THIS_MODULE,
 	.llseek = cpuid_seek,
 	.read = cpuid_read,
diff -puN arch/i386/kernel/microcode.c~mark-struct-file_operations-const-2 arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~mark-struct-file_operations-const-2
+++ a/arch/i386/kernel/microcode.c
@@ -451,7 +451,7 @@ static ssize_t microcode_write (struct f
 	return ret;
 }
 
-static struct file_operations microcode_fops = {
+static const struct file_operations microcode_fops = {
 	.owner		= THIS_MODULE,
 	.write		= microcode_write,
 	.open		= microcode_open,
diff -puN arch/i386/kernel/msr.c~mark-struct-file_operations-const-2 arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~mark-struct-file_operations-const-2
+++ a/arch/i386/kernel/msr.c
@@ -225,7 +225,7 @@ static int msr_open(struct inode *inode,
 /*
  * File operations we support
  */
-static struct file_operations msr_fops = {
+static const struct file_operations msr_fops = {
 	.owner = THIS_MODULE,
 	.llseek = msr_seek,
 	.read = msr_read,
diff -puN arch/ia64/hp/common/sba_iommu.c~mark-struct-file_operations-const-2 arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~mark-struct-file_operations-const-2
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1881,7 +1881,7 @@ ioc_open(struct inode *inode, struct fil
 	return seq_open(file, &ioc_seq_ops);
 }
 
-static struct file_operations ioc_fops = {
+static const struct file_operations ioc_fops = {
 	.open    = ioc_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff -puN arch/ia64/kernel/perfmon.c~mark-struct-file_operations-const-2 arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~mark-struct-file_operations-const-2
+++ a/arch/ia64/kernel/perfmon.c
@@ -621,7 +621,7 @@ EXPORT_PER_CPU_SYMBOL_GPL(pfm_syst_info)
 
 
 /* forward declaration */
-static struct file_operations pfm_file_ops;
+static const struct file_operations pfm_file_ops;
 
 /*
  * forward declarations
@@ -2126,7 +2126,7 @@ pfm_no_open(struct inode *irrelevant, st
 
 
 
-static struct file_operations pfm_file_ops = {
+static const struct file_operations pfm_file_ops = {
 	.llseek   = no_llseek,
 	.read     = pfm_read,
 	.write    = pfm_write,
@@ -6596,7 +6596,7 @@ found:
 	return 0;
 }
 
-static struct file_operations pfm_proc_fops = {
+static const struct file_operations pfm_proc_fops = {
 	.open		= pfm_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/ia64/kernel/salinfo.c~mark-struct-file_operations-const-2 arch/ia64/kernel/salinfo.c
--- a/arch/ia64/kernel/salinfo.c~mark-struct-file_operations-const-2
+++ a/arch/ia64/kernel/salinfo.c
@@ -352,7 +352,7 @@ retry:
 	return size;
 }
 
-static struct file_operations salinfo_event_fops = {
+static const struct file_operations salinfo_event_fops = {
 	.open  = salinfo_event_open,
 	.read  = salinfo_event_read,
 };
@@ -568,7 +568,7 @@ salinfo_log_write(struct file *file, con
 	return count;
 }
 
-static struct file_operations salinfo_data_fops = {
+static const struct file_operations salinfo_data_fops = {
 	.open    = salinfo_log_open,
 	.release = salinfo_log_release,
 	.read    = salinfo_log_read,
diff -puN arch/ia64/sn/kernel/sn2/sn2_smp.c~mark-struct-file_operations-const-2 arch/ia64/sn/kernel/sn2/sn2_smp.c
--- a/arch/ia64/sn/kernel/sn2/sn2_smp.c~mark-struct-file_operations-const-2
+++ a/arch/ia64/sn/kernel/sn2/sn2_smp.c
@@ -455,7 +455,7 @@ static int sn2_ptc_proc_open(struct inod
 	return seq_open(file, &sn2_ptc_seq_ops);
 }
 
-static struct file_operations proc_sn2_ptc_operations = {
+static const struct file_operations proc_sn2_ptc_operations = {
 	.open = sn2_ptc_proc_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -puN arch/ia64/sn/kernel/sn2/sn_hwperf.c~mark-struct-file_operations-const-2 arch/ia64/sn/kernel/sn2/sn_hwperf.c
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c~mark-struct-file_operations-const-2
+++ a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -865,7 +865,7 @@ error:
 	return r;
 }
 
-static struct file_operations sn_hwperf_fops = {
+static const struct file_operations sn_hwperf_fops = {
 	.ioctl = sn_hwperf_ioctl,
 };
 
diff -puN arch/m68k/bvme6000/rtc.c~mark-struct-file_operations-const-2 arch/m68k/bvme6000/rtc.c
--- a/arch/m68k/bvme6000/rtc.c~mark-struct-file_operations-const-2
+++ a/arch/m68k/bvme6000/rtc.c
@@ -159,7 +159,7 @@ static int rtc_release(struct inode *ino
  *	The various file operations we support.
  */
 
-static struct file_operations rtc_fops = {
+static const struct file_operations rtc_fops = {
 	.ioctl =	rtc_ioctl,
 	.open =		rtc_open,
 	.release =	rtc_release,
diff -puN arch/m68k/mvme16x/rtc.c~mark-struct-file_operations-const-2 arch/m68k/mvme16x/rtc.c
--- a/arch/m68k/mvme16x/rtc.c~mark-struct-file_operations-const-2
+++ a/arch/m68k/mvme16x/rtc.c
@@ -147,7 +147,7 @@ static int rtc_release(struct inode *ino
  *	The various file operations we support.
  */
 
-static struct file_operations rtc_fops = {
+static const struct file_operations rtc_fops = {
 	.ioctl =	rtc_ioctl,
 	.open =		rtc_open,
 	.release =	rtc_release,
diff -puN arch/mips/kernel/apm.c~mark-struct-file_operations-const-2 arch/mips/kernel/apm.c
--- a/arch/mips/kernel/apm.c~mark-struct-file_operations-const-2
+++ a/arch/mips/kernel/apm.c
@@ -379,7 +379,7 @@ static int apm_open(struct inode * inode
 	return as ? 0 : -ENOMEM;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
diff -puN arch/mips/kernel/rtlx.c~mark-struct-file_operations-const-2 arch/mips/kernel/rtlx.c
--- a/arch/mips/kernel/rtlx.c~mark-struct-file_operations-const-2
+++ a/arch/mips/kernel/rtlx.c
@@ -476,7 +476,7 @@ static ssize_t file_write(struct file *f
 	return rtlx_write(minor, (void *)buffer, count, 1);
 }
 
-static struct file_operations rtlx_fops = {
+static const struct file_operations rtlx_fops = {
 	.owner =   THIS_MODULE,
 	.open =    file_open,
 	.release = file_release,
diff -puN arch/mips/kernel/vpe.c~mark-struct-file_operations-const-2 arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~mark-struct-file_operations-const-2
+++ a/arch/mips/kernel/vpe.c
@@ -1202,7 +1202,7 @@ static ssize_t vpe_write(struct file *fi
 	return ret;
 }
 
-static struct file_operations vpe_fops = {
+static const struct file_operations vpe_fops = {
 	.owner = THIS_MODULE,
 	.open = vpe_open,
 	.release = vpe_release,
diff -puN arch/mips/sibyte/sb1250/bcm1250_tbprof.c~mark-struct-file_operations-const-2 arch/mips/sibyte/sb1250/bcm1250_tbprof.c
--- a/arch/mips/sibyte/sb1250/bcm1250_tbprof.c~mark-struct-file_operations-const-2
+++ a/arch/mips/sibyte/sb1250/bcm1250_tbprof.c
@@ -374,7 +374,7 @@ static long sbprof_tb_ioctl(struct file 
 	return error;
 }
 
-static struct file_operations sbprof_tb_fops = {
+static const struct file_operations sbprof_tb_fops = {
 	.owner		= THIS_MODULE,
 	.open		= sbprof_tb_open,
 	.release	= sbprof_tb_release,
diff -puN arch/parisc/kernel/perf.c~mark-struct-file_operations-const-2 arch/parisc/kernel/perf.c
--- a/arch/parisc/kernel/perf.c~mark-struct-file_operations-const-2
+++ a/arch/parisc/kernel/perf.c
@@ -479,7 +479,7 @@ static long perf_ioctl(struct file *file
 	return error;
 }
 
-static struct file_operations perf_fops = {
+static const struct file_operations perf_fops = {
 	.llseek = no_llseek,
 	.read = perf_read,
 	.write = perf_write,
diff -puN arch/powerpc/kernel/lparcfg.c~mark-struct-file_operations-const-2 arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -571,7 +571,7 @@ static int lparcfg_open(struct inode *in
 	return single_open(file, lparcfg_data, NULL);
 }
 
-struct file_operations lparcfg_fops = {
+const struct file_operations lparcfg_fops = {
 	.owner		= THIS_MODULE,
 	.read		= seq_read,
 	.write		= lparcfg_write,
diff -puN arch/powerpc/kernel/nvram_64.c~mark-struct-file_operations-const-2 arch/powerpc/kernel/nvram_64.c
--- a/arch/powerpc/kernel/nvram_64.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/kernel/nvram_64.c
@@ -179,7 +179,7 @@ static int dev_nvram_ioctl(struct inode 
 	}
 }
 
-struct file_operations nvram_fops = {
+const struct file_operations nvram_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	dev_nvram_llseek,
 	.read =		dev_nvram_read,
diff -puN arch/powerpc/kernel/proc_ppc64.c~mark-struct-file_operations-const-2 arch/powerpc/kernel/proc_ppc64.c
--- a/arch/powerpc/kernel/proc_ppc64.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/kernel/proc_ppc64.c
@@ -33,7 +33,7 @@ static ssize_t page_map_read( struct fil
 			      loff_t *ppos);
 static int     page_map_mmap( struct file *file, struct vm_area_struct *vma );
 
-static struct file_operations page_map_fops = {
+static const struct file_operations page_map_fops = {
 	.llseek	= page_map_seek,
 	.read	= page_map_read,
 	.mmap	= page_map_mmap
diff -puN arch/powerpc/kernel/rtas-proc.c~mark-struct-file_operations-const-2 arch/powerpc/kernel/rtas-proc.c
--- a/arch/powerpc/kernel/rtas-proc.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/kernel/rtas-proc.c
@@ -160,7 +160,7 @@ static int sensors_open(struct inode *in
 	return single_open(file, ppc_rtas_sensors_show, NULL);
 }
 
-struct file_operations ppc_rtas_sensors_operations = {
+const struct file_operations ppc_rtas_sensors_operations = {
 	.open		= sensors_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -172,7 +172,7 @@ static int poweron_open(struct inode *in
 	return single_open(file, ppc_rtas_poweron_show, NULL);
 }
 
-struct file_operations ppc_rtas_poweron_operations = {
+const struct file_operations ppc_rtas_poweron_operations = {
 	.open		= poweron_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -185,7 +185,7 @@ static int progress_open(struct inode *i
 	return single_open(file, ppc_rtas_progress_show, NULL);
 }
 
-struct file_operations ppc_rtas_progress_operations = {
+const struct file_operations ppc_rtas_progress_operations = {
 	.open		= progress_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -198,7 +198,7 @@ static int clock_open(struct inode *inod
 	return single_open(file, ppc_rtas_clock_show, NULL);
 }
 
-struct file_operations ppc_rtas_clock_operations = {
+const struct file_operations ppc_rtas_clock_operations = {
 	.open		= clock_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -211,7 +211,7 @@ static int tone_freq_open(struct inode *
 	return single_open(file, ppc_rtas_tone_freq_show, NULL);
 }
 
-struct file_operations ppc_rtas_tone_freq_operations = {
+const struct file_operations ppc_rtas_tone_freq_operations = {
 	.open		= tone_freq_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -224,7 +224,7 @@ static int tone_volume_open(struct inode
 	return single_open(file, ppc_rtas_tone_volume_show, NULL);
 }
 
-struct file_operations ppc_rtas_tone_volume_operations = {
+const struct file_operations ppc_rtas_tone_volume_operations = {
 	.open		= tone_volume_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -237,7 +237,7 @@ static int rmo_buf_open(struct inode *in
 	return single_open(file, ppc_rtas_rmo_buf_show, NULL);
 }
 
-struct file_operations ppc_rtas_rmo_buf_ops = {
+const struct file_operations ppc_rtas_rmo_buf_ops = {
 	.open		= rmo_buf_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/powerpc/kernel/rtas_flash.c~mark-struct-file_operations-const-2 arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -702,7 +702,7 @@ static int initialize_flash_pde_data(con
 }
 
 static struct proc_dir_entry *create_flash_pde(const char *filename,
-					       struct file_operations *fops)
+					       const struct file_operations *fops)
 {
 	struct proc_dir_entry *ent = NULL;
 
@@ -715,21 +715,21 @@ static struct proc_dir_entry *create_fla
 	return ent;
 }
 
-static struct file_operations rtas_flash_operations = {
+static const struct file_operations rtas_flash_operations = {
 	.read		= rtas_flash_read,
 	.write		= rtas_flash_write,
 	.open		= rtas_excl_open,
 	.release	= rtas_flash_release,
 };
 
-static struct file_operations manage_flash_operations = {
+static const struct file_operations manage_flash_operations = {
 	.read		= manage_flash_read,
 	.write		= manage_flash_write,
 	.open		= rtas_excl_open,
 	.release	= rtas_excl_release,
 };
 
-static struct file_operations validate_flash_operations = {
+static const struct file_operations validate_flash_operations = {
 	.read		= validate_flash_read,
 	.write		= validate_flash_write,
 	.open		= rtas_excl_open,
diff -puN arch/powerpc/platforms/cell/spufs/file.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -144,7 +144,7 @@ spufs_mem_mmap(struct file *file, struct
 	return 0;
 }
 
-static struct file_operations spufs_mem_fops = {
+static const struct file_operations spufs_mem_fops = {
 	.open	 = spufs_mem_open,
 	.read    = spufs_mem_read,
 	.write   = spufs_mem_write,
@@ -249,7 +249,7 @@ static int spufs_cntl_open(struct inode 
 					spufs_cntl_set, "0x%08lx");
 }
 
-static struct file_operations spufs_cntl_fops = {
+static const struct file_operations spufs_cntl_fops = {
 	.open = spufs_cntl_open,
 	.release = simple_attr_close,
 	.read = simple_attr_read,
@@ -309,7 +309,7 @@ spufs_regs_write(struct file *file, cons
 	return ret;
 }
 
-static struct file_operations spufs_regs_fops = {
+static const struct file_operations spufs_regs_fops = {
 	.open	 = spufs_regs_open,
 	.read    = spufs_regs_read,
 	.write   = spufs_regs_write,
@@ -360,7 +360,7 @@ spufs_fpcr_write(struct file *file, cons
 	return ret;
 }
 
-static struct file_operations spufs_fpcr_fops = {
+static const struct file_operations spufs_fpcr_fops = {
 	.open = spufs_regs_open,
 	.read = spufs_fpcr_read,
 	.write = spufs_fpcr_write,
@@ -426,7 +426,7 @@ static ssize_t spufs_mbox_read(struct fi
 	return count;
 }
 
-static struct file_operations spufs_mbox_fops = {
+static const struct file_operations spufs_mbox_fops = {
 	.open	= spufs_pipe_open,
 	.read	= spufs_mbox_read,
 };
@@ -452,7 +452,7 @@ static ssize_t spufs_mbox_stat_read(stru
 	return 4;
 }
 
-static struct file_operations spufs_mbox_stat_fops = {
+static const struct file_operations spufs_mbox_stat_fops = {
 	.open	= spufs_pipe_open,
 	.read	= spufs_mbox_stat_read,
 };
@@ -559,7 +559,7 @@ static unsigned int spufs_ibox_poll(stru
 	return mask;
 }
 
-static struct file_operations spufs_ibox_fops = {
+static const struct file_operations spufs_ibox_fops = {
 	.open	= spufs_pipe_open,
 	.read	= spufs_ibox_read,
 	.poll	= spufs_ibox_poll,
@@ -585,7 +585,7 @@ static ssize_t spufs_ibox_stat_read(stru
 	return 4;
 }
 
-static struct file_operations spufs_ibox_stat_fops = {
+static const struct file_operations spufs_ibox_stat_fops = {
 	.open	= spufs_pipe_open,
 	.read	= spufs_ibox_stat_read,
 };
@@ -692,7 +692,7 @@ static unsigned int spufs_wbox_poll(stru
 	return mask;
 }
 
-static struct file_operations spufs_wbox_fops = {
+static const struct file_operations spufs_wbox_fops = {
 	.open	= spufs_pipe_open,
 	.write	= spufs_wbox_write,
 	.poll	= spufs_wbox_poll,
@@ -718,7 +718,7 @@ static ssize_t spufs_wbox_stat_read(stru
 	return 4;
 }
 
-static struct file_operations spufs_wbox_stat_fops = {
+static const struct file_operations spufs_wbox_stat_fops = {
 	.open	= spufs_pipe_open,
 	.read	= spufs_wbox_stat_read,
 };
@@ -823,7 +823,7 @@ static int spufs_signal1_mmap(struct fil
 	return 0;
 }
 
-static struct file_operations spufs_signal1_fops = {
+static const struct file_operations spufs_signal1_fops = {
 	.open = spufs_signal1_open,
 	.read = spufs_signal1_read,
 	.write = spufs_signal1_write,
@@ -934,7 +934,7 @@ static int spufs_signal2_mmap(struct fil
 #define spufs_signal2_mmap NULL
 #endif /* !SPUFS_MMAP_4K */
 
-static struct file_operations spufs_signal2_fops = {
+static const struct file_operations spufs_signal2_fops = {
 	.open = spufs_signal2_open,
 	.read = spufs_signal2_read,
 	.write = spufs_signal2_write,
@@ -1037,7 +1037,7 @@ static int spufs_mss_open(struct inode *
 	return nonseekable_open(inode, file);
 }
 
-static struct file_operations spufs_mss_fops = {
+static const struct file_operations spufs_mss_fops = {
 	.open	 = spufs_mss_open,
 	.mmap	 = spufs_mss_mmap,
 };
@@ -1076,7 +1076,7 @@ static int spufs_psmap_open(struct inode
 	return nonseekable_open(inode, file);
 }
 
-static struct file_operations spufs_psmap_fops = {
+static const struct file_operations spufs_psmap_fops = {
 	.open	 = spufs_psmap_open,
 	.mmap	 = spufs_psmap_mmap,
 };
@@ -1393,7 +1393,7 @@ static int spufs_mfc_fasync(int fd, stru
 	return fasync_helper(fd, file, on, &ctx->mfc_fasync);
 }
 
-static struct file_operations spufs_mfc_fops = {
+static const struct file_operations spufs_mfc_fops = {
 	.open	 = spufs_mfc_open,
 	.read	 = spufs_mfc_read,
 	.write	 = spufs_mfc_write,
@@ -1650,7 +1650,7 @@ static ssize_t spufs_mbox_info_read(stru
 	return ret;
 }
 
-static struct file_operations spufs_mbox_info_fops = {
+static const struct file_operations spufs_mbox_info_fops = {
 	.open = spufs_info_open,
 	.read = spufs_mbox_info_read,
 	.llseek  = generic_file_llseek,
@@ -1688,7 +1688,7 @@ static ssize_t spufs_ibox_info_read(stru
 	return ret;
 }
 
-static struct file_operations spufs_ibox_info_fops = {
+static const struct file_operations spufs_ibox_info_fops = {
 	.open = spufs_info_open,
 	.read = spufs_ibox_info_read,
 	.llseek  = generic_file_llseek,
@@ -1729,7 +1729,7 @@ static ssize_t spufs_wbox_info_read(stru
 	return ret;
 }
 
-static struct file_operations spufs_wbox_info_fops = {
+static const struct file_operations spufs_wbox_info_fops = {
 	.open = spufs_info_open,
 	.read = spufs_wbox_info_read,
 	.llseek  = generic_file_llseek,
@@ -1779,7 +1779,7 @@ static ssize_t spufs_dma_info_read(struc
 	return ret;
 }
 
-static struct file_operations spufs_dma_info_fops = {
+static const struct file_operations spufs_dma_info_fops = {
 	.open = spufs_info_open,
 	.read = spufs_dma_info_read,
 };
@@ -1830,7 +1830,7 @@ static ssize_t spufs_proxydma_info_read(
 	return ret;
 }
 
-static struct file_operations spufs_proxydma_info_fops = {
+static const struct file_operations spufs_proxydma_info_fops = {
 	.open = spufs_info_open,
 	.read = spufs_proxydma_info_read,
 };
diff -puN arch/powerpc/platforms/cell/spufs/inode.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/cell/spufs/inode.c
--- a/arch/powerpc/platforms/cell/spufs/inode.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/cell/spufs/inode.c
@@ -224,7 +224,7 @@ struct inode_operations spufs_dir_inode_
 	.lookup = simple_lookup,
 };
 
-struct file_operations spufs_context_fops = {
+const struct file_operations spufs_context_fops = {
 	.open		= dcache_dir_open,
 	.release	= spufs_dir_close,
 	.llseek		= dcache_dir_lseek,
@@ -372,7 +372,7 @@ static int spufs_gang_close(struct inode
 	return dcache_dir_close(inode, file);
 }
 
-struct file_operations spufs_gang_fops = {
+const struct file_operations spufs_gang_fops = {
 	.open		= dcache_dir_open,
 	.release	= spufs_gang_close,
 	.llseek		= dcache_dir_lseek,
diff -puN arch/powerpc/platforms/iseries/lpevents.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/iseries/lpevents.c
--- a/arch/powerpc/platforms/iseries/lpevents.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/iseries/lpevents.c
@@ -308,7 +308,7 @@ static int proc_lpevents_open(struct ino
 	return single_open(file, proc_lpevents_show, NULL);
 }
 
-static struct file_operations proc_lpevents_operations = {
+static const struct file_operations proc_lpevents_operations = {
 	.open		= proc_lpevents_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/powerpc/platforms/iseries/mf.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -1224,7 +1224,7 @@ out:
 	return rc;
 }
 
-static struct file_operations proc_vmlinux_operations = {
+static const struct file_operations proc_vmlinux_operations = {
 	.write		= proc_mf_change_vmlinux,
 };
 
diff -puN arch/powerpc/platforms/iseries/proc.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/iseries/proc.c
--- a/arch/powerpc/platforms/iseries/proc.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/iseries/proc.c
@@ -101,7 +101,7 @@ static int proc_titantod_open(struct ino
 	return single_open(file, proc_titantod_show, NULL);
 }
 
-static struct file_operations proc_titantod_operations = {
+static const struct file_operations proc_titantod_operations = {
 	.open		= proc_titantod_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/powerpc/platforms/iseries/viopath.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/iseries/viopath.c
--- a/arch/powerpc/platforms/iseries/viopath.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/iseries/viopath.c
@@ -173,7 +173,7 @@ static int proc_viopath_open(struct inod
 	return single_open(file, proc_viopath_show, NULL);
 }
 
-static struct file_operations proc_viopath_operations = {
+static const struct file_operations proc_viopath_operations = {
 	.open		= proc_viopath_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN arch/powerpc/platforms/pseries/eeh.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/pseries/eeh.c
--- a/arch/powerpc/platforms/pseries/eeh.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/pseries/eeh.c
@@ -1065,7 +1065,7 @@ static int proc_eeh_open(struct inode *i
 	return single_open(file, proc_eeh_show, NULL);
 }
 
-static struct file_operations proc_eeh_operations = {
+static const struct file_operations proc_eeh_operations = {
 	.open      = proc_eeh_open,
 	.read      = seq_read,
 	.llseek    = seq_lseek,
diff -puN arch/powerpc/platforms/pseries/hvCall_inst.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/pseries/hvCall_inst.c
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -90,7 +90,7 @@ static int hcall_inst_seq_open(struct in
 	return rc;
 }
 
-static struct file_operations hcall_inst_seq_fops = {
+static const struct file_operations hcall_inst_seq_fops = {
 	.open = hcall_inst_seq_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -puN arch/powerpc/platforms/pseries/reconfig.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/pseries/reconfig.c
@@ -499,7 +499,7 @@ out:
 	return rv ? rv : count;
 }
 
-static struct file_operations ofdt_fops = {
+static const struct file_operations ofdt_fops = {
 	.write = ofdt_write
 };
 
diff -puN arch/powerpc/platforms/pseries/rtasd.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/pseries/rtasd.c
--- a/arch/powerpc/platforms/pseries/rtasd.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/pseries/rtasd.c
@@ -331,7 +331,7 @@ static unsigned int rtas_log_poll(struct
 	return 0;
 }
 
-struct file_operations proc_rtas_log_operations = {
+const struct file_operations proc_rtas_log_operations = {
 	.read =		rtas_log_read,
 	.poll =		rtas_log_poll,
 	.open =		rtas_log_open,
diff -puN arch/powerpc/platforms/pseries/scanlog.c~mark-struct-file_operations-const-2 arch/powerpc/platforms/pseries/scanlog.c
--- a/arch/powerpc/platforms/pseries/scanlog.c~mark-struct-file_operations-const-2
+++ a/arch/powerpc/platforms/pseries/scanlog.c
@@ -184,7 +184,7 @@ static int scanlog_release(struct inode 
 	return 0;
 }
 
-struct file_operations scanlog_fops = {
+const struct file_operations scanlog_fops = {
 	.owner		= THIS_MODULE,
 	.read		= scanlog_read,
 	.write		= scanlog_write,
diff -puN arch/ppc/8xx_io/cs4218_tdm.c~mark-struct-file_operations-const-2 arch/ppc/8xx_io/cs4218_tdm.c
--- a/arch/ppc/8xx_io/cs4218_tdm.c~mark-struct-file_operations-const-2
+++ a/arch/ppc/8xx_io/cs4218_tdm.c
@@ -1711,7 +1711,7 @@ static int mixer_ioctl(struct inode *ino
 }
 
 
-static struct file_operations mixer_fops =
+static const struct file_operations mixer_fops =
 {
 	.owner =	THIS_MODULE,
 	.llseek =	sound_lseek,
@@ -2298,7 +2298,7 @@ static int sq_ioctl(struct inode *inode,
 
 
 
-static struct file_operations sq_fops =
+static const struct file_operations sq_fops =
 {
 	.owner =	THIS_MODULE,
 	.llseek =	sound_lseek,
@@ -2433,7 +2433,7 @@ static ssize_t state_read(struct file *f
 }
 
 
-static struct file_operations state_fops =
+static const struct file_operations state_fops =
 {
 	.owner =	THIS_MODULE,
 	.llseek =	sound_lseek,
diff -puN arch/s390/hypfs/inode.c~mark-struct-file_operations-const-2 arch/s390/hypfs/inode.c
--- a/arch/s390/hypfs/inode.c~mark-struct-file_operations-const-2
+++ a/arch/s390/hypfs/inode.c
@@ -35,7 +35,7 @@ struct hypfs_sb_info {
 	struct mutex lock;		/* lock to protect update process */
 };
 
-static struct file_operations hypfs_file_ops;
+static const struct file_operations hypfs_file_ops;
 static struct file_system_type hypfs_type;
 static struct super_operations hypfs_s_ops;
 
@@ -435,7 +435,7 @@ struct dentry *hypfs_create_str(struct s
 	return dentry;
 }
 
-static struct file_operations hypfs_file_ops = {
+static const struct file_operations hypfs_file_ops = {
 	.open		= hypfs_open,
 	.release	= hypfs_release,
 	.read		= do_sync_read,
diff -puN arch/s390/kernel/debug.c~mark-struct-file_operations-const-2 arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~mark-struct-file_operations-const-2
+++ a/arch/s390/kernel/debug.c
@@ -167,7 +167,7 @@ static DECLARE_MUTEX(debug_lock);
 
 static int initialized;
 
-static struct file_operations debug_file_ops = {
+static const struct file_operations debug_file_ops = {
 	.owner   = THIS_MODULE,
 	.read    = debug_output,
 	.write   = debug_input,
diff -puN arch/sh/boards/landisk/landisk_pwb.c~mark-struct-file_operations-const-2 arch/sh/boards/landisk/landisk_pwb.c
--- a/arch/sh/boards/landisk/landisk_pwb.c~mark-struct-file_operations-const-2
+++ a/arch/sh/boards/landisk/landisk_pwb.c
@@ -150,7 +150,7 @@ static irqreturn_t sw_interrupt(int irq,
 	return IRQ_HANDLED;
 }
 
-static struct file_operations swdrv_fops = {
+static const struct file_operations swdrv_fops = {
 	.read = swdrv_read,	/* read */
 	.write = swdrv_write,	/* write */
 	.open = swdrv_open,	/* open */
diff -puN arch/sh/kernel/apm.c~mark-struct-file_operations-const-2 arch/sh/kernel/apm.c
--- a/arch/sh/kernel/apm.c~mark-struct-file_operations-const-2
+++ a/arch/sh/kernel/apm.c
@@ -385,7 +385,7 @@ static int apm_open(struct inode * inode
 	return as ? 0 : -ENOMEM;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
diff -puN arch/sh/mm/cache-debugfs.c~mark-struct-file_operations-const-2 arch/sh/mm/cache-debugfs.c
--- a/arch/sh/mm/cache-debugfs.c~mark-struct-file_operations-const-2
+++ a/arch/sh/mm/cache-debugfs.c
@@ -114,7 +114,7 @@ static int cache_debugfs_open(struct ino
 	return single_open(file, cache_seq_show, inode->i_private);
 }
 
-static struct file_operations cache_debugfs_fops = {
+static const struct file_operations cache_debugfs_fops = {
 	.owner		= THIS_MODULE,
 	.open		= cache_debugfs_open,
 	.read		= seq_read,
diff -puN arch/sh/mm/pmb.c~mark-struct-file_operations-const-2 arch/sh/mm/pmb.c
--- a/arch/sh/mm/pmb.c~mark-struct-file_operations-const-2
+++ a/arch/sh/mm/pmb.c
@@ -378,7 +378,7 @@ static int pmb_debugfs_open(struct inode
 	return single_open(file, pmb_seq_show, NULL);
 }
 
-static struct file_operations pmb_debugfs_fops = {
+static const struct file_operations pmb_debugfs_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pmb_debugfs_open,
 	.read		= seq_read,
diff -puN arch/sh/oprofile/op_model_sh7750.c~mark-struct-file_operations-const-2 arch/sh/oprofile/op_model_sh7750.c
--- a/arch/sh/oprofile/op_model_sh7750.c~mark-struct-file_operations-const-2
+++ a/arch/sh/oprofile/op_model_sh7750.c
@@ -187,7 +187,7 @@ static ssize_t sh7750_write_count(struct
 	return count;
 }
 
-static struct file_operations count_fops = {
+static const struct file_operations count_fops = {
 	.read		= sh7750_read_count,
 	.write		= sh7750_write_count,
 };
diff -puN arch/sparc/kernel/apc.c~mark-struct-file_operations-const-2 arch/sparc/kernel/apc.c
--- a/arch/sparc/kernel/apc.c~mark-struct-file_operations-const-2
+++ a/arch/sparc/kernel/apc.c
@@ -127,7 +127,7 @@ static int apc_ioctl(struct inode *inode
 	return 0;
 }
 
-static struct file_operations apc_fops = {
+static const struct file_operations apc_fops = {
 	.ioctl =	apc_ioctl,
 	.open =		apc_open,
 	.release =	apc_release,
diff -puN arch/sparc64/kernel/time.c~mark-struct-file_operations-const-2 arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~mark-struct-file_operations-const-2
+++ a/arch/sparc64/kernel/time.c
@@ -1327,7 +1327,7 @@ static int mini_rtc_release(struct inode
 }
 
 
-static struct file_operations mini_rtc_fops = {
+static const struct file_operations mini_rtc_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= mini_rtc_ioctl,
 	.open		= mini_rtc_open,
diff -puN arch/sparc64/solaris/socksys.c~mark-struct-file_operations-const-2 arch/sparc64/solaris/socksys.c
--- a/arch/sparc64/solaris/socksys.c~mark-struct-file_operations-const-2
+++ a/arch/sparc64/solaris/socksys.c
@@ -55,7 +55,7 @@ extern void mykfree(void *);
 
 static unsigned int (*sock_poll)(struct file *, poll_table *);
 
-static struct file_operations socksys_file_ops = {
+static const struct file_operations socksys_file_ops = {
 	/* Currently empty */
 };
 
@@ -163,7 +163,7 @@ static unsigned int socksys_poll(struct 
 	return mask;
 }
 	
-static struct file_operations socksys_fops = {
+static const struct file_operations socksys_fops = {
 	.open =		socksys_open,
 	.release =	socksys_release,
 };
diff -puN arch/um/drivers/harddog_kern.c~mark-struct-file_operations-const-2 arch/um/drivers/harddog_kern.c
--- a/arch/um/drivers/harddog_kern.c~mark-struct-file_operations-const-2
+++ a/arch/um/drivers/harddog_kern.c
@@ -145,7 +145,7 @@ static int harddog_ioctl(struct inode *i
 	}
 }
 
-static struct file_operations harddog_fops = {
+static const struct file_operations harddog_fops = {
 	.owner		= THIS_MODULE,
 	.write		= harddog_write,
 	.ioctl		= harddog_ioctl,
diff -puN arch/v850/kernel/rte_cb_leds.c~mark-struct-file_operations-const-2 arch/v850/kernel/rte_cb_leds.c
--- a/arch/v850/kernel/rte_cb_leds.c~mark-struct-file_operations-const-2
+++ a/arch/v850/kernel/rte_cb_leds.c
@@ -117,7 +117,7 @@ static loff_t leds_dev_lseek (struct fil
 	return 0;
 }
 
-static struct file_operations leds_fops = {
+static const struct file_operations leds_fops = {
 	.read		= leds_dev_read,
 	.write		= leds_dev_write,
 	.llseek		= leds_dev_lseek
diff -puN arch/x86_64/kernel/mce.c~mark-struct-file_operations-const-2 arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~mark-struct-file_operations-const-2
+++ a/arch/x86_64/kernel/mce.c
@@ -537,7 +537,7 @@ static int mce_ioctl(struct inode *i, st
 	} 
 }
 
-static struct file_operations mce_chrdev_ops = {
+static const struct file_operations mce_chrdev_ops = {
 	.read = mce_read,
 	.ioctl = mce_ioctl,
 };
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
