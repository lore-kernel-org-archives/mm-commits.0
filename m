From: akpm@linux-foundation.org
Subject: [merged] doc-alphabetize-kernel-parameterstxt.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:08:39 -0800
Message-ID: <200902172008.n1HK8dFx000927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbZBQUJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:09:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc: alphabetize kernel-parameters.txt
has been removed from the -mm tree.  Its filename was
     doc-alphabetize-kernel-parameterstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: alphabetize kernel-parameters.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

kernel-parameters.txt specifies that entries are supposed to be in
alpha order, so rearrange lots of entries to support that.

Also clean up some vertical whitespace.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |  472 ++++++++++++--------------
 1 file changed, 234 insertions(+), 238 deletions(-)

diff -puN Documentation/kernel-parameters.txt~doc-alphabetize-kernel-parameterstxt Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-alphabetize-kernel-parameterstxt
+++ a/Documentation/kernel-parameters.txt
@@ -151,60 +151,6 @@ and is between 256 and 4096 characters. 
 			1,0: use 1st APIC table
 			default: 0
 
-	acpi_sleep=	[HW,ACPI] Sleep options
-			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
-				  old_ordering, s4_nonvs }
-			See Documentation/power/video.txt for information on
-			s3_bios and s3_mode.
-			s3_beep is for debugging; it makes the PC's speaker beep
-			as soon as the kernel's real-mode entry point is called.
-			s4_nohwsig prevents ACPI hardware signature from being
-			used during resume from hibernation.
-			old_ordering causes the ACPI 1.0 ordering of the _PTS
-			control method, with respect to putting devices into
-			low power states, to be enforced (the ACPI 2.0 ordering
-			of _PTS is used by default).
-			s4_nonvs prevents the kernel from saving/restoring the
-			ACPI NVS memory during hibernation.
-
-	acpi_sci=	[HW,ACPI] ACPI System Control Interrupt trigger mode
-			Format: { level | edge | high | low }
-
-	acpi_irq_balance [HW,ACPI]
-			ACPI will balance active IRQs
-			default in APIC mode
-
-	acpi_irq_nobalance [HW,ACPI]
-			ACPI will not move active IRQs (default)
-			default in PIC mode
-
-	acpi_irq_pci=	[HW,ACPI] If irq_balance, clear listed IRQs for
-			use by PCI
-			Format: <irq>,<irq>...
-
-	acpi_irq_isa=	[HW,ACPI] If irq_balance, mark listed IRQs used by ISA
-			Format: <irq>,<irq>...
-
-	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
-
-	acpi_os_name=	[HW,ACPI] Tell ACPI BIOS the name of the OS
-			Format: To spoof as Windows 98: ="Microsoft Windows"
-
-	acpi_osi=	[HW,ACPI] Modify list of supported OS interface strings
-			acpi_osi="string1"	# add string1 -- only one string
-			acpi_osi="!string2"	# remove built-in string2
-			acpi_osi=		# disable all strings
-
-	acpi_serialize	[HW,ACPI] force serialization of AML methods
-
-	acpi_skip_timer_override [HW,ACPI]
-			Recognize and ignore IRQ0/pin2 Interrupt Override.
-			For broken nForce2 BIOS resulting in XT-PIC timer.
-	acpi_use_timer_override [HW,ACPI]
-			Use timer override. For some broken Nvidia NF5 boards
-			that require a timer override, but don't have
-			HPET
-
 	acpi_backlight=	[HW,ACPI]
 			acpi_backlight=vendor
 			acpi_backlight=video
@@ -212,11 +158,6 @@ and is between 256 and 4096 characters. 
 			(e.g. thinkpad_acpi, sony_acpi, etc.) instead
 			of the ACPI video.ko driver.
 
-	acpi_display_output=	[HW,ACPI]
-			acpi_display_output=vendor
-			acpi_display_output=video
-			See above.
-
 	acpi.debug_layer=	[HW,ACPI,ACPI_DEBUG]
 	acpi.debug_level=	[HW,ACPI,ACPI_DEBUG]
 			Format: <int>
@@ -245,6 +186,41 @@ and is between 256 and 4096 characters. 
 			unusable.  The "log_buf_len" parameter may be useful
 			if you need to capture more output.
 
+	acpi_display_output=	[HW,ACPI]
+			acpi_display_output=vendor
+			acpi_display_output=video
+			See above.
+
+	acpi_irq_balance [HW,ACPI]
+			ACPI will balance active IRQs
+			default in APIC mode
+
+	acpi_irq_nobalance [HW,ACPI]
+			ACPI will not move active IRQs (default)
+			default in PIC mode
+
+	acpi_irq_isa=	[HW,ACPI] If irq_balance, mark listed IRQs used by ISA
+			Format: <irq>,<irq>...
+
+	acpi_irq_pci=	[HW,ACPI] If irq_balance, clear listed IRQs for
+			use by PCI
+			Format: <irq>,<irq>...
+
+	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
+
+	acpi_os_name=	[HW,ACPI] Tell ACPI BIOS the name of the OS
+			Format: To spoof as Windows 98: ="Microsoft Windows"
+
+	acpi_osi=	[HW,ACPI] Modify list of supported OS interface strings
+			acpi_osi="string1"	# add string1 -- only one string
+			acpi_osi="!string2"	# remove built-in string2
+			acpi_osi=		# disable all strings
+
+	acpi_pm_good	[X86-32,X86-64]
+			Override the pmtimer bug detection: force the kernel
+			to assume that this machine's pmtimer latches its value
+			and always returns good values.
+
  	acpi.power_nocheck=	[HW,ACPI]
  			Format: 1/0 enable/disable the check of power state.
  			On some bogus BIOS the _PSC object/_STA object of
@@ -253,30 +229,41 @@ and is between 256 and 4096 characters. 
  			power state again in power transition.
  			1 : disable the power state check
 
-	acpi_pm_good	[X86-32,X86-64]
-			Override the pmtimer bug detection: force the kernel
-			to assume that this machine's pmtimer latches its value
-			and always returns good values.
+	acpi_sci=	[HW,ACPI] ACPI System Control Interrupt trigger mode
+			Format: { level | edge | high | low }
 
-	agp=		[AGP]
-			{ off | try_unsupported }
-			off: disable AGP support
-			try_unsupported: try to drive unsupported chipsets
-				(may crash computer or cause data corruption)
+	acpi_serialize	[HW,ACPI] force serialization of AML methods
 
-	enable_timer_pin_1 [i386,x86-64]
-			Enable PIN 1 of APIC timer
-			Can be useful to work around chipset bugs
-			(in particular on some ATI chipsets).
-			The kernel tries to set a reasonable default.
+	acpi_skip_timer_override [HW,ACPI]
+			Recognize and ignore IRQ0/pin2 Interrupt Override.
+			For broken nForce2 BIOS resulting in XT-PIC timer.
 
-	disable_timer_pin_1 [i386,x86-64]
-			Disable PIN 1 of APIC timer
-			Can be useful to work around chipset bugs.
+	acpi_sleep=	[HW,ACPI] Sleep options
+			Format: { s3_bios, s3_mode, s3_beep, s4_nohwsig,
+				  old_ordering, s4_nonvs }
+			See Documentation/power/video.txt for information on
+			s3_bios and s3_mode.
+			s3_beep is for debugging; it makes the PC's speaker beep
+			as soon as the kernel's real-mode entry point is called.
+			s4_nohwsig prevents ACPI hardware signature from being
+			used during resume from hibernation.
+			old_ordering causes the ACPI 1.0 ordering of the _PTS
+			control method, with respect to putting devices into
+			low power states, to be enforced (the ACPI 2.0 ordering
+			of _PTS is used by default).
+			s4_nonvs prevents the kernel from saving/restoring the
+			ACPI NVS memory during hibernation.
+
+	acpi_use_timer_override [HW,ACPI]
+			Use timer override. For some broken Nvidia NF5 boards
+			that require a timer override, but don't have HPET
 
 	ad1848=		[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>,<type>
 
+	add_efi_memmap	[EFI; x86-32,X86-64] Include EFI memory map in
+			kernel's map of available physical RAM.
+
 	advansys=	[HW,SCSI]
 			See header of drivers/scsi/advansys.c.
 
@@ -287,6 +274,12 @@ and is between 256 and 4096 characters. 
 			Format: <io>,<irq>,<dma>,<mss_io>,<mpu_io>,<mpu_irq>
 			See also header of sound/oss/aedsp16.c.
 
+	agp=		[AGP]
+			{ off | try_unsupported }
+			off: disable AGP support
+			try_unsupported: try to drive unsupported chipsets
+				(may crash computer or cause data corruption)
+
 	aha152x=	[HW,SCSI]
 			See Documentation/scsi/aha152x.txt.
 
@@ -414,12 +407,6 @@ and is between 256 and 4096 characters. 
 			possible to determine what the correct size should be.
 			This option provides an override for these situations.
 
-	security=	[SECURITY] Choose a security module to enable at boot.
-			If this boot parameter is not specified, only the first
-			security module asking for security registration will be
-			loaded. An invalid security module name will be treated
-			as if no module has been chosen.
-
 	capability.disable=
 			[SECURITY] Disable capabilities.  This would normally
 			be used only if an alternative security model is to be
@@ -491,12 +478,6 @@ and is between 256 and 4096 characters. 
 			Range: 0 - 8192
 			Default: 64
 
-	hpet=		[X86-32,HPET] option to control HPET usage
-			Format: { enable (default) | disable | force }
-			disable: disable HPET and use PIT instead
-			force: allow force enabled of undocumented chips (ICH4,
-			VIA, nVidia)
-
 	com20020=	[HW,NET] ARCnet - COM20020 chipset
 			Format:
 			<io>[,<irq>[,<nodeID>[,<backplane>[,<ckp>[,<timeout>]]]]]
@@ -540,23 +521,6 @@ and is between 256 and 4096 characters. 
 			console=brl,ttyS0
 		For now, only VisioBraille is supported.
 
-	earlycon=	[KNL] Output early console device and options.
-		uart[8250],io,<addr>[,options]
-		uart[8250],mmio,<addr>[,options]
-			Start an early, polled-mode console on the 8250/16550
-			UART at the specified I/O port or MMIO address.
-			The options are the same as for ttyS, above.
-
-	no_console_suspend
-			[HW] Never suspend the console
-			Disable suspending of consoles during suspend and
-			hibernate operations.  Once disabled, debugging
-			messages can reach various consoles while the rest
-			of the system is being put to sleep (ie, while
-			debugging driver suspend/resume hooks).  This may
-			not work reliably with all consoles, but is known
-			to work with serial and VGA consoles.
-
 	coredump_filter=
 			[KNL] Change the default value for
 			/proc/<pid>/coredump_filter.
@@ -610,30 +574,13 @@ and is between 256 and 4096 characters. 
 			Format: <area>[,<node>]
 			See also Documentation/networking/decnet.txt.
 
-	vt.default_blu=	[VT]
-			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
-			Change the default blue palette of the console.
-			This is a 16-member array composed of values
-			ranging from 0-255.
-
-	vt.default_grn=	[VT]
-			Format: <green0>,<green1>,<green2>,...,<green15>
-			Change the default green palette of the console.
-			This is a 16-member array composed of values
-			ranging from 0-255.
-
-	vt.default_red=	[VT]
-			Format: <red0>,<red1>,<red2>,...,<red15>
-			Change the default red palette of the console.
-			This is a 16-member array composed of values
-			ranging from 0-255.
-
-	vt.default_utf8=
-			[VT]
-			Format=<0|1>
-			Set system-wide default UTF-8 mode for all tty's.
-			Default is 1, i.e. UTF-8 mode is enabled for all
-			newly opened terminals.
+	default_hugepagesz=
+			[same as hugepagesz=] The size of the default
+			HugeTLB page size. This is the size represented by
+			the legacy /proc/ hugepages APIs, used for SHM, and
+			default size when mounting hugetlbfs filesystems.
+			Defaults to the default architecture's huge page size
+			if not specified.
 
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
@@ -646,27 +593,9 @@ and is between 256 and 4096 characters. 
 			Documentation/serial/digiepca.txt.
 
 	disable_mtrr_cleanup [X86]
-	enable_mtrr_cleanup [X86]
 			The kernel tries to adjust MTRR layout from continuous
 			to discrete, to make X server driver able to add WB
-			entry later. This parameter enables/disables that.
-
-	mtrr_chunk_size=nn[KMG] [X86]
-			used for mtrr cleanup. It is largest continous chunk
-			that could hold holes aka. UC entries.
-
-	mtrr_gran_size=nn[KMG] [X86]
-			Used for mtrr cleanup. It is granularity of mtrr block.
-			Default is 1.
-			Large value could prevent small alignment from
-			using up MTRRs.
-
-	mtrr_spare_reg_nr=n [X86]
-			Format: <integer>
-			Range: 0,7 : spare reg number
-			Default : 1
-			Used for mtrr cleanup. It is spare mtrr entries number.
-			Set to 2 or more if your graphical card needs more.
+			entry later. This parameter disables that.
 
 	disable_mtrr_trim [X86, Intel and AMD only]
 			By default the kernel will trim any uncacheable
@@ -674,12 +603,28 @@ and is between 256 and 4096 characters. 
 			MTRR settings.  This parameter disables that behavior,
 			possibly causing your machine to run very slowly.
 
+	disable_timer_pin_1 [i386,x86-64]
+			Disable PIN 1 of APIC timer
+			Can be useful to work around chipset bugs.
+
 	dmasound=	[HW,OSS] Sound subsystem buffers
 
 	dscc4.setup=	[NET]
 
 	dtc3181e=	[HW,SCSI]
 
+	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
+			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
+			These can also be switched on/off via
+			<debugfs>/dynamic_printk/modules
+
+	earlycon=	[KNL] Output early console device and options.
+		uart[8250],io,<addr>[,options]
+		uart[8250],mmio,<addr>[,options]
+			Start an early, polled-mode console on the 8250/16550
+			UART at the specified I/O port or MMIO address.
+			The options are the same as for ttyS, above.
+
 	earlyprintk=	[X86-32,X86-64,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
@@ -721,6 +666,17 @@ and is between 256 and 4096 characters. 
 			pass this option to capture kernel.
 			See Documentation/kdump/kdump.txt for details.
 
+	enable_mtrr_cleanup [X86]
+			The kernel tries to adjust MTRR layout from continuous
+			to discrete, to make X server driver able to add WB
+			entry later. This parameter enables that.
+
+	enable_timer_pin_1 [i386,x86-64]
+			Enable PIN 1 of APIC timer
+			Can be useful to work around chipset bugs
+			(in particular on some ATI chipsets).
+			The kernel tries to set a reasonable default.
+
 	enforcing	[SELINUX] Set initial enforcing status.
 			Format: {"0" | "1"}
 			See security/selinux/Kconfig help text.
@@ -808,6 +764,14 @@ and is between 256 and 4096 characters. 
 	hisax=		[HW,ISDN]
 			See Documentation/isdn/README.HiSax.
 
+	hlt		[BUGS=ARM,SH]
+
+	hpet=		[X86-32,HPET] option to control HPET usage
+			Format: { enable (default) | disable | force }
+			disable: disable HPET and use PIT instead
+			force: allow force enabled of undocumented chips (ICH4,
+			VIA, nVidia)
+
 	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
 	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
 			On x86-64 and powerpc, this option can be specified
@@ -817,15 +781,6 @@ and is between 256 and 4096 characters. 
 			(when the CPU supports the "pdpe1gb" cpuinfo flag)
 			Note that 1GB pages can only be allocated at boot time
 			using hugepages= and not freed afterwards.
-	default_hugepagesz=
-			[same as hugepagesz=] The size of the default
-			HugeTLB page size. This is the size represented by
-			the legacy /proc/ hugepages APIs, used for SHM, and
-			default size when mounting hugetlbfs filesystems.
-			Defaults to the default architecture's huge page size
-			if not specified.
-
-	hlt		[BUGS=ARM,SH]
 
 	hvc_iucv=	[S390] Number of z/VM IUCV hypervisor console (HVC)
 			       terminal devices. Valid values: 0..8
@@ -875,6 +830,9 @@ and is between 256 and 4096 characters. 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
 			See Documentation/ide/ide.txt.
 
+	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
+			Claim all unknown PCI IDE storage controllers.
+
 	idle=		[X86]
 			Format: idle=poll, idle=mwait, idle=halt, idle=nomwait
 			Poll forces a polling idle loop that can slightly
@@ -890,9 +848,6 @@ and is between 256 and 4096 characters. 
 			In such case C2/C3 won't be used again.
 			idle=nomwait: Disable mwait for CPU C-states
 
-	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
-			Claim all unknown PCI IDE storage controllers.
-
 	ignore_loglevel	[KNL]
 			Ignore loglevel setting - this will print /all/
 			kernel messages to the console. Useful for debugging.
@@ -917,25 +872,6 @@ and is between 256 and 4096 characters. 
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
 			Format: <irq>
 
-	inttest=	[IA64]
-
-	iomem=		Disable strict checking of access to MMIO memory
-		strict	regions from userspace.
-		relaxed
-
-	iommu=		[x86]
-		off
-		force
-		noforce
-		biomerge
-		panic
-		nopanic
-		merge
-		nomerge
-		forcesac
-		soft
-
-
 	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
 		on
 			Enable intel iommu driver.
@@ -959,6 +895,28 @@ and is between 256 and 4096 characters. 
 			result in a hardware IOTLB flush operation as opposed
 			to batching them for performance.
 
+	inttest=	[IA64]
+
+	iomem=		Disable strict checking of access to MMIO memory
+		strict	regions from userspace.
+		relaxed
+
+	iommu=		[x86]
+		off
+		force
+		noforce
+		biomerge
+		panic
+		nopanic
+		merge
+		nomerge
+		forcesac
+		soft
+
+	io7=		[HW] IO7 for Marvel based alpha systems
+			See comment before marvel_specify_io7 in
+			arch/alpha/kernel/core_marvel.c.
+
 	io_delay=	[X86-32,X86-64] I/O delay method
 		0x80
 			Standard port 0x80 based delay
@@ -969,10 +927,6 @@ and is between 256 and 4096 characters. 
 		none
 			No delay
 
-	io7=		[HW] IO7 for Marvel based alpha systems
-			See comment before marvel_specify_io7 in
-			arch/alpha/kernel/core_marvel.c.
-
 	ip=		[IP_PNP]
 			See Documentation/filesystems/nfsroot.txt.
 
@@ -983,12 +937,6 @@ and is between 256 and 4096 characters. 
 	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
 			See header of drivers/scsi/ips.c.
 
-	ports=		[IP_VS_FTP] IPVS ftp helper module
-			Default is 21.
-			Up to 8 (IP_VS_APP_MAX_PORTS) ports
-			may be specified.
-			Format: <port>,<port>....
-
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
 			for it. Intended to get systems with badly broken
@@ -1029,6 +977,8 @@ and is between 256 and 4096 characters. 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
+	keepinitrd	[HW,ARM]
+
 	kernelcore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
 			specifies the amount of memory usable by the kernel
 			for non-movable allocations.  The requested amount is
@@ -1045,21 +995,6 @@ and is between 256 and 4096 characters. 
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
-	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
-			is similar to kernelcore except it specifies the
-			amount of memory used for migratable allocations.
-			If both kernelcore and movablecore is specified,
-			then kernelcore will be at *least* the specified
-			value but may be more. If movablecore on its own
-			is specified, the administrator must be careful
-			that the amount of memory usable for all allocations
-			is not too small.
-
-	keepinitrd	[HW,ARM]
-
-	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
-			in oops dumps.
-
 	kgdboc=		[HW] kgdb over consoles.
 			Requires a tty driver that supports console polling.
 			(only serial suported for now)
@@ -1069,6 +1004,9 @@ and is between 256 and 4096 characters. 
 			Configure the RouterBoard 532 series on-chip
 			Ethernet adapter MAC address.
 
+	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
+			in oops dumps.
+
 	l2cr=		[PPC]
 
 	l3cr=		[PPC]
@@ -1214,9 +1152,8 @@ and is between 256 and 4096 characters. 
 			(machvec) in a generic kernel.
 			Example: machvec=hpzx1_swiotlb
 
-	max_loop=	[LOOP] Maximum number of loopback devices that can
-			be mounted
-			Format: <1-256>
+	max_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory greater
+			than or equal to this physical address is ignored.
 
 	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
 			should make use of.  maxcpus=n : n >= 0 limits the
@@ -1224,8 +1161,9 @@ and is between 256 and 4096 characters. 
 			it is equivalent to "nosmp", which also disables
 			the IO APIC.
 
-	max_addr=nn[KMG]	[KNL,BOOT,ia64] All physical memory greater than
-			or equal to this physical address is ignored.
+	max_loop=	[LOOP] Maximum number of loopback devices that can
+			be mounted
+			Format: <1-256>
 
 	max_luns=	[SCSI] Maximum number of LUNs to probe.
 			Should be between 1 and 2^32-1.
@@ -1347,6 +1285,16 @@ and is between 256 and 4096 characters. 
 	mousedev.yres=	[MOUSE] Vertical screen resolution, used for devices
 			reporting absolute coordinates, such as tablets
 
+	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
+			is similar to kernelcore except it specifies the
+			amount of memory used for migratable allocations.
+			If both kernelcore and movablecore is specified,
+			then kernelcore will be at *least* the specified
+			value but may be more. If movablecore on its own
+			is specified, the administrator must be careful
+			that the amount of memory usable for all allocations
+			is not too small.
+
 	mpu401=		[HW,OSS]
 			Format: <io>,<irq>
 
@@ -1368,6 +1316,23 @@ and is between 256 and 4096 characters. 
 			[HW] Make the MicroTouch USB driver use raw coordinates
 			('y', default) or cooked coordinates ('n')
 
+	mtrr_chunk_size=nn[KMG] [X86]
+			used for mtrr cleanup. It is largest continous chunk
+			that could hold holes aka. UC entries.
+
+	mtrr_gran_size=nn[KMG] [X86]
+			Used for mtrr cleanup. It is granularity of mtrr block.
+			Default is 1.
+			Large value could prevent small alignment from
+			using up MTRRs.
+
+	mtrr_spare_reg_nr=n [X86]
+			Format: <integer>
+			Range: 0,7 : spare reg number
+			Default : 1
+			Used for mtrr cleanup. It is spare mtrr entries number.
+			Set to 2 or more if your graphical card needs more.
+
 	n2=		[NET] SDL Inc. RISCom/N2 synchronous serial card
 
 	NCR_D700=	[HW,SCSI]
@@ -1441,6 +1406,16 @@ and is between 256 and 4096 characters. 
 			emulation library even if a 387 maths coprocessor
 			is present.
 
+	no_console_suspend
+			[HW] Never suspend the console
+			Disable suspending of consoles during suspend and
+			hibernate operations.  Once disabled, debugging
+			messages can reach various consoles while the rest
+			of the system is being put to sleep (ie, while
+			debugging driver suspend/resume hooks).  This may
+			not work reliably with all consoles, but is known
+			to work with serial and VGA consoles.
+
 	noaliencache	[MM, NUMA, SLAB] Disables the allocation of alien
 			caches in the slab allocator.  Saves per-node memory,
 			but will impact performance.
@@ -1455,6 +1430,8 @@ and is between 256 and 4096 characters. 
 
 	nocache		[ARM]
 
+	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
+
 	nodelayacct	[KNL] Disable per-task delay accounting
 
 	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
@@ -1483,8 +1460,6 @@ and is between 256 and 4096 characters. 
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
-	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
-
 	nohlt		[BUGS=ARM,SH]
 
 	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
@@ -1525,12 +1500,6 @@ and is between 256 and 4096 characters. 
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
-	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
-
-	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
-			default x2apic cluster mode on platforms
-			supporting x2apic.
-
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
@@ -1541,6 +1510,9 @@ and is between 256 and 4096 characters. 
 	nomfgpt		[X86-32] Disable Multi-Function General Purpose
 			Timer usage (for AMD Geode machines).
 
+	norandmaps	Don't use address space randomization.  Equivalent to
+			echo 0 > /proc/sys/kernel/randomize_va_space
+
 	noreplace-paravirt	[X86-32,PV_OPS] Don't patch paravirt_ops
 
 	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
@@ -1579,13 +1551,13 @@ and is between 256 and 4096 characters. 
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
 
+	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
+
 	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
 			one of ['zone', 'node', 'default'] can be specified
 			This can be set from sysctl after boot.
 			See Documentation/sysctl/vm.txt for details.
 
-	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
-
 	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
 			See Documentation/debugging-via-ohci1394.txt for more
 			info.
@@ -1814,11 +1786,6 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
-	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
-			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
-			These can also be switched on/off via
-			<debugfs>/dynamic_printk/modules
-
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
 			print-fatal-signals=1: print segfault info to
@@ -1828,6 +1795,14 @@ and is between 256 and 4096 characters. 
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
+	processor.max_cstate=	[HW,ACPI]
+			Limit processor to maximum C-state
+			max_cstate=9 overrides any DMI blacklist limit.
+
+	processor.nocst	[HW,ACPI]
+			Ignore the _CST method to determine C-states,
+			instead using the legacy FADT method
+
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
@@ -1837,14 +1812,6 @@ and is between 256 and 4096 characters. 
 				Requires CONFIG_SCHEDSTATS
 			Param: "kvm" - profile VM exits.
 
-	processor.max_cstate=	[HW,ACPI]
-			Limit processor to maximum C-state
-			max_cstate=9 overrides any DMI blacklist limit.
-
-	processor.nocst	[HW,ACPI]
-			Ignore the _CST method to determine C-states,
-			instead using the legacy FADT method
-
 	prompt_ramdisk=	[RAM] List of RAM disks to prompt for floppy disk
 			before loading.
 			See Documentation/blockdev/ramdisk.txt.
@@ -1998,6 +1965,12 @@ and is between 256 and 4096 characters. 
 			allowing boot to proceed.  none ignores them, expecting
 			user space to do the scan.
 
+	security=	[SECURITY] Choose a security module to enable at boot.
+			If this boot parameter is not specified, only the first
+			security module asking for security registration will be
+			loaded. An invalid security module name will be treated
+			as if no module has been chosen.
+
 	selinux		[SELINUX] Disable or enable SELinux at boot time.
 			Format: { "0" | "1" }
 			See security/selinux/Kconfig help text.
@@ -2429,9 +2402,6 @@ and is between 256 and 4096 characters. 
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
-	add_efi_memmap	[EFI; x86-32,X86-64] Include EFI memory map in
-			kernel's map of available physical RAM.
-
 	vdso=		[X86-32,SH,x86-64]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
@@ -2470,6 +2440,31 @@ and is between 256 and 4096 characters. 
 	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
 			Format: <command>
 
+	vt.default_blu=	[VT]
+			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
+			Change the default blue palette of the console.
+			This is a 16-member array composed of values
+			ranging from 0-255.
+
+	vt.default_grn=	[VT]
+			Format: <green0>,<green1>,<green2>,...,<green15>
+			Change the default green palette of the console.
+			This is a 16-member array composed of values
+			ranging from 0-255.
+
+	vt.default_red=	[VT]
+			Format: <red0>,<red1>,<red2>,...,<red15>
+			Change the default red palette of the console.
+			This is a 16-member array composed of values
+			ranging from 0-255.
+
+	vt.default_utf8=
+			[VT]
+			Format=<0|1>
+			Set system-wide default UTF-8 mode for all tty's.
+			Default is 1, i.e. UTF-8 mode is enabled for all
+			newly opened terminals.
+
 	waveartist=	[HW,OSS]
 			Format: <io>,<irq>,<dma>,<dma2>
 
@@ -2482,6 +2477,10 @@ and is between 256 and 4096 characters. 
 	wdt=		[WDT] Watchdog
 			See Documentation/watchdog/wdt.txt.
 
+	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
+			default x2apic cluster mode on platforms
+			supporting x2apic.
+
 	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
 	xd_geo=		See header of drivers/block/xd.c.
 
@@ -2489,9 +2488,6 @@ and is between 256 and 4096 characters. 
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
 
-	norandmaps	Don't use address space randomization.  Equivalent to
-			echo 0 > /proc/sys/kernel/randomize_va_space
-
 ______________________________________________________________________
 
 TODO:
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
x86-dell-laptop-depends-on-power_supply.patch
x86-oqo-depends-on-input_polldev.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

