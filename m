Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C524CC004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 13:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjASNE0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjASNDf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 08:03:35 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BABD4B497
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 05:02:42 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 7F951604F2;
        Thu, 19 Jan 2023 14:02:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1674133359; bh=XPlH47UMhO3495fDoVJ69McoOtbXrQ+cm1xMxmFywx0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=TD6/7st5WqTKn29azBieCuKrkUjwPBoO00YNAeK3WdIp6FxQbsV5YNMXsmsWKXIA9
         YrkKIIAhbfoUinhBnv4EqZVOsRpK+WbQ1dn65hZsDbuVBnFWj6WGjRhyEO8RVOgd4c
         8qEVs1TTsqDSw/IbN5ZUILdxzqh9RVop8Ck67vvtDS8JD/aazQ2dudhCC75bIUOQg8
         POTVf1SCJqVjqp3h+10VI64FBtNWHXADKO70MV3aPsCu/JrWJJaqiSQFRmHR5wFK7i
         xp17tR8dsLUZBge4UZsGESqTqT9C5NyWahX1fdbuCn7cLcP3uFxEH2pu6sZABdhIBW
         hTTprOSEyK6BA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7YAR2E0daooi; Thu, 19 Jan 2023 14:02:36 +0100 (CET)
Received: from [161.53.83.51] (pc-mtodorov.grf.hr [161.53.83.51])
        by domac.alu.hr (Postfix) with ESMTPSA id 7942B604F0;
        Thu, 19 Jan 2023 14:02:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1674133356; bh=XPlH47UMhO3495fDoVJ69McoOtbXrQ+cm1xMxmFywx0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=s4t0fuRQ7+DXTLLIYFFVJVJnGSWBybPWkKZZuYVLGcRHI28Kgx6BYJVEf+LCifcrK
         /8N2sa1OMiphg04fYtK2+CDg7Zumm1d6vAnfNtEInWer7B4Ob18E6OYXfWifWZGrnF
         YZsbjlaqgw87GxRAjPGL6OhqS+kllCz9g/V1rheovHD8Ow80WuII4O9qLc7xs4DfJa
         WZISOJvRdjHRJ2ZcMM1X5apU+kFEhVuDAQbe9ZHpiIqJ1JHNkV9o4aqugQQ37626z9
         efSS/ySmZbVuatZvfhusus6uFErWYgl/1PVexE9D3MKc2bsRF64o9HwnTt94kbw/Bh
         uHz/q/zaVJZ5A==
Message-ID: <a6ff1869-d90e-3d3c-b023-3a95b4bc7eaf@alu.unizg.hr>
Date:   Thu, 19 Jan 2023 14:02:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: + mm-use-stack_depot_early_init-for-kmemleak.patch added to
 mm-hotfixes-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        nathan@kernel.org, ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        catalin.marinas@arm.com, zhaoyang.huang@unisoc.com
References: <20230118001933.5E38DC433F1@smtp.kernel.org>
Content-Language: en-US
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <20230118001933.5E38DC433F1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi,

On 18.1.2023. 1:19, Andrew Morton wrote:
> The patch titled
>       Subject: mm: use stack_depot_early_init for kmemleak
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-use-stack_depot_early_init-for-kmemleak.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-stack_depot_early_init-for-kmemleak.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> Subject: mm: use stack_depot_early_init for kmemleak
> Date: Tue, 17 Jan 2023 16:11:52 +0800
> 
> Mirsad report bellow error which caused by stack_depot_init failed in
> kvcalloc.  Solve this by having stackdepot use stack_depot_early_init.
> Extra Kconfig also done by moving kmemleak stuff to mm/Kconfig.debug.
> 
> On 1/4/23 17:08, Mirsad Goran Todorovac wrote:
> I hate to bring bad news again, but there seems to be a problem with the output of /sys/kernel/debug/kmemleak:
> 
> [root@pc-mtodorov ~]# cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff951c118568b0 (size 16):
> comm "kworker/u12:2", pid 56, jiffies 4294893952 (age 4356.548s)
>      hex dump (first 16 bytes):
>        6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00 memstick0.......
>      backtrace:
>   [root@pc-mtodorov ~]#
>     Apparently, backtrace of called functions on the stack is no longer printed with the list of memory leaks.
>   This appeared on Lenovo desktop 10TX000VCR, with AlmaLinux 8.7 and BIOS version M22KT49A (11/10/2022)
>   and 6.2-rc1 and 6.2-rc2 builds.
>   This worked on 6.1 with the same CONFIG_KMEMLEAK=y and MGLRU enabled on a vanilla mainstream kernel
>   from Mr. Torvalds' tree. I don't know if this is deliberate feature for some reason or a bug.
>   Please find attached the config, lshw and kmemleak output.
> 
> Link: https://lkml.kernel.org/r/1673943112-8620-1-git-send-email-zhaoyang.huang@unisoc.com
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: ke.wang <ke.wang@unisoc.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
> 
> --- a/lib/Kconfig.debug~mm-use-stack_depot_early_init-for-kmemleak
> +++ a/lib/Kconfig.debug
> @@ -743,76 +743,6 @@ config SHRINKER_DEBUG
>   	  visibility into the kernel memory shrinkers subsystem.
>   	  Disable it to avoid an extra memory footprint.
>   
> -config HAVE_DEBUG_KMEMLEAK
> -	bool
> -
> -config DEBUG_KMEMLEAK
> -	bool "Kernel memory leak detector"
> -	depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
> -	select DEBUG_FS
> -	select STACKTRACE if STACKTRACE_SUPPORT
> -	select KALLSYMS
> -	select CRC32
> -	select STACKDEPOT
> -	help
> -	  Say Y here if you want to enable the memory leak
> -	  detector. The memory allocation/freeing is traced in a way
> -	  similar to the Boehm's conservative garbage collector, the
> -	  difference being that the orphan objects are not freed but
> -	  only shown in /sys/kernel/debug/kmemleak. Enabling this
> -	  feature will introduce an overhead to memory
> -	  allocations. See Documentation/dev-tools/kmemleak.rst for more
> -	  details.
> -
> -	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
> -	  of finding leaks due to the slab objects poisoning.
> -
> -	  In order to access the kmemleak file, debugfs needs to be
> -	  mounted (usually at /sys/kernel/debug).
> -
> -config DEBUG_KMEMLEAK_MEM_POOL_SIZE
> -	int "Kmemleak memory pool size"
> -	depends on DEBUG_KMEMLEAK
> -	range 200 1000000
> -	default 16000
> -	help
> -	  Kmemleak must track all the memory allocations to avoid
> -	  reporting false positives. Since memory may be allocated or
> -	  freed before kmemleak is fully initialised, use a static pool
> -	  of metadata objects to track such callbacks. After kmemleak is
> -	  fully initialised, this memory pool acts as an emergency one
> -	  if slab allocations fail.
> -
> -config DEBUG_KMEMLEAK_TEST
> -	tristate "Simple test for the kernel memory leak detector"
> -	depends on DEBUG_KMEMLEAK && m
> -	help
> -	  This option enables a module that explicitly leaks memory.
> -
> -	  If unsure, say N.
> -
> -config DEBUG_KMEMLEAK_DEFAULT_OFF
> -	bool "Default kmemleak to off"
> -	depends on DEBUG_KMEMLEAK
> -	help
> -	  Say Y here to disable kmemleak by default. It can then be enabled
> -	  on the command line via kmemleak=on.
> -
> -config DEBUG_KMEMLEAK_AUTO_SCAN
> -	bool "Enable kmemleak auto scan thread on boot up"
> -	default y
> -	depends on DEBUG_KMEMLEAK
> -	help
> -	  Depending on the cpu, kmemleak scan may be cpu intensive and can
> -	  stall user tasks at times. This option enables/disables automatic
> -	  kmemleak scan at boot up.
> -
> -	  Say N here to disable kmemleak auto scan thread to stop automatic
> -	  scanning. Disabling this option disables automatic reporting of
> -	  memory leaks.
> -
> -	  If unsure, say Y.
> -
>   config DEBUG_STACK_USAGE
>   	bool "Stack utilization instrumentation"
>   	depends on DEBUG_KERNEL && !IA64
> --- a/mm/Kconfig.debug~mm-use-stack_depot_early_init-for-kmemleak
> +++ a/mm/Kconfig.debug
> @@ -207,3 +207,73 @@ config PTDUMP_DEBUGFS
>   	  kernel.
>   
>   	  If in doubt, say N.
> +
> +config HAVE_DEBUG_KMEMLEAK
> +	bool
> +
> +config DEBUG_KMEMLEAK
> +	bool "Kernel memory leak detector"
> +	depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
> +	select DEBUG_FS
> +	select STACKTRACE if STACKTRACE_SUPPORT
> +	select KALLSYMS
> +	select CRC32
> +	select STACKDEPOT
> +	help
> +	  Say Y here if you want to enable the memory leak
> +	  detector. The memory allocation/freeing is traced in a way
> +	  similar to the Boehm's conservative garbage collector, the
> +	  difference being that the orphan objects are not freed but
> +	  only shown in /sys/kernel/debug/kmemleak. Enabling this
> +	  feature will introduce an overhead to memory
> +	  allocations. See Documentation/dev-tools/kmemleak.rst for more
> +	  details.
> +
> +	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
> +	  of finding leaks due to the slab objects poisoning.
> +
> +	  In order to access the kmemleak file, debugfs needs to be
> +	  mounted (usually at /sys/kernel/debug).
> +
> +config DEBUG_KMEMLEAK_MEM_POOL_SIZE
> +	int "Kmemleak memory pool size"
> +	depends on DEBUG_KMEMLEAK
> +	range 200 1000000
> +	default 16000
> +	help
> +	  Kmemleak must track all the memory allocations to avoid
> +	  reporting false positives. Since memory may be allocated or
> +	  freed before kmemleak is fully initialised, use a static pool
> +	  of metadata objects to track such callbacks. After kmemleak is
> +	  fully initialised, this memory pool acts as an emergency one
> +	  if slab allocations fail.
> +
> +config DEBUG_KMEMLEAK_TEST
> +	tristate "Simple test for the kernel memory leak detector"
> +	depends on DEBUG_KMEMLEAK && m
> +	help
> +	  This option enables a module that explicitly leaks memory.
> +
> +	  If unsure, say N.
> +
> +config DEBUG_KMEMLEAK_DEFAULT_OFF
> +	bool "Default kmemleak to off"
> +	depends on DEBUG_KMEMLEAK
> +	help
> +	  Say Y here to disable kmemleak by default. It can then be enabled
> +	  on the command line via kmemleak=on.
> +
> +config DEBUG_KMEMLEAK_AUTO_SCAN
> +	bool "Enable kmemleak auto scan thread on boot up"
> +	default y
> +	depends on DEBUG_KMEMLEAK
> +	help
> +	  Depending on the cpu, kmemleak scan may be cpu intensive and can
> +	  stall user tasks at times. This option enables/disables automatic
> +	  kmemleak scan at boot up.
> +
> +	  Say N here to disable kmemleak auto scan thread to stop automatic
> +	  scanning. Disabling this option disables automatic reporting of
> +	  memory leaks.
> +
> +	  If unsure, say Y.
> --- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
> +++ a/mm/kmemleak.c
> @@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
>   		return -EINVAL;
>   	if (strcmp(str, "off") == 0)
>   		kmemleak_disable();
> -	else if (strcmp(str, "on") == 0)
> +	else if (strcmp(str, "on") == 0) {
>   		kmemleak_skip_disable = 1;
> +		stack_depot_want_early_init();
> +	}
>   	else
>   		return -EINVAL;
>   	return 0;
> _
> 
> Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are
> 
> mm-use-stack_depot_early_init-for-kmemleak.patch

Dear Sir,

Please note that this patch activates stack_depot_want_early_init() only when
kernel boot param "kmemleak=on" is used.

When the following configuration is used:

CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y

... and there is no kmemleak boot param, then the stack_depot_want_early_init()
is not being called and Stack Depot tries initialisation with kvalloc() in
stack_depot_init(), which failed in the initial bug report.

So IMHO this patch defeats the purpose of having CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
unset and gives a severed stack backtrace because Stack Depot is not allocated,
triggering a bug in vmalloc(), which from Googling might be because of requesting
8.4 MB too early, but I am not an expert on mm.

Here is the dmesg output with this patch on and kmemleak=on not set.

If I understood well, kmemleak_boot_config() is called only when kmemleak=on|off
boot param is present, and otherwise stack_depot_want_early_init() is not being
called.

Nothing else touched the __stack_depot_want_early_init variable, judging from
grep of the source:

static bool __stack_depot_want_early_init __initdata = IS_ENABLED(CONFIG_STACKDEPOT_ALWAYS_INIT);

Dmesg output:

[    0.034444] software IO TLB: area num 8.
[    0.072098] Memory: 16152084K/16658536K available (18432K kernel code, 4118K rwdata, 7184K rodata, 4424K init, 7680K bss, 506192K 
reserved, 0K cma-reserved)
[    0.072287] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.072290] Stack Depot allocating hash table of 1048576 entries with kvcalloc
[    0.072294] swapper: vmalloc error: size 8388608, vm_struct allocation failed, mode:0xdc0(GFP_KERNEL|__GFP_ZERO), 
nodemask=(null),cpuset=(null),mems_allowed=0-1023
[    0.072303] CPU: 0 PID: 0 Comm: swapper Not tainted 6.2.0-rc4-mglru-kmemlk-patch-zhaoyang4+ #1
[    0.072306] Hardware name: LENOVO 10TX000VCR/3140, BIOS M22KT49A 11/10/2022
[    0.072307] Call Trace:
[    0.072308]  <TASK>
[    0.072311]  dump_stack_lvl+0x49/0x63
[    0.072316]  dump_stack+0x10/0x16
[    0.072319]  warn_alloc.cold.161+0x75/0xe8
[    0.072323]  ? __get_vm_area_node+0x14d/0x160
[    0.072328]  __vmalloc_node_range+0x5e5/0x7d0
[    0.072332]  ? stack_depot_init.cold.2+0x7e/0xb3
[    0.072335]  ? __kmalloc_large_node+0xf8/0x150
[    0.072338]  ? kvmalloc_node+0x4f/0xe0
[    0.072341]  kvmalloc_node+0xb1/0xe0
[    0.072344]  ? stack_depot_init.cold.2+0x7e/0xb3
[    0.072346]  stack_depot_init.cold.2+0x7e/0xb3
[    0.072348]  kmemleak_init+0x1b/0x10a
[    0.072352]  start_kernel+0x710/0x9dc
[    0.072356]  x86_64_start_reservations+0x24/0x2a
[    0.072358]  x86_64_start_kernel+0xf2/0xfd
[    0.072360]  secondary_startup_64_no_verify+0xe5/0xeb
[    0.072366]  </TASK>
[    0.072367] Mem-Info:
[    0.072368] active_anon:0 inactive_anon:0 isolated_anon:0
                 active_file:0 inactive_file:0 isolated_file:0
                 unevictable:0 dirty:0 writeback:0
                 slab_reclaimable:0 slab_unreclaimable:26
                 mapped:0 shmem:0 pagetables:0
                 sec_pagetables:0 bounce:0
                 kernel_misc_reclaimable:0
                 free:4037995 free_pcp:0 free_cma:0
[    0.072373] Node 0 active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB mapped:0kB dirty:0kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB writeback_tmp:0kB 
kernel_stack:0kB pagetables:0kB sec_pagetables:0kB all_unreclaimable? no
[    0.072377] Node 0 DMA free:14336kB boost:0kB min:0kB low:0kB high:0kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15992kB managed:14336kB mlocked:0kB bounce:0kB 
free_pcp:0kB local_pcp:0kB free_cma:0kB
[    0.072381] lowmem_reserve[]: 0 0 0 0 0
[    0.072385] Node 0 DMA32 free:2085160kB boost:0kB min:0kB low:0kB high:0kB reserved_highatomic:0KB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:2257392kB managed:2085160kB mlocked:0kB 
bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[    0.072388] lowmem_reserve[]: 0 0 0 0 0
[    0.072391] Node 0 Normal free:14052484kB boost:0kB min:0kB low:0kB high:0kB reserved_highatomic:0KB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:14385152kB managed:14052848kB 
mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[    0.072395] lowmem_reserve[]: 0 0 0 0 0
[    0.072398] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 2*1024kB (UM) 2*2048kB (M) 2*4096kB (M) = 14336kB
[    0.072409] Node 0 DMA32: 8*4kB (M) 9*8kB (M) 8*16kB (M) 8*32kB (M) 7*64kB (M) 7*128kB (M) 8*256kB (M) 7*512kB (M) 5*1024kB (M) 
6*2048kB (M) 503*4096kB (M) = 2085160kB
[    0.072423] Node 0 Normal: 9*4kB (UM) 8*8kB (M) 2*16kB (UM) 2*32kB (M) 1*64kB (M) 3*128kB (UM) 2*256kB (M) 4*512kB (UM) 2*1024kB 
(UM) 1*2048kB (U) 3429*4096kB (M) = 14052484kB
[    0.072437] 0 total pagecache pages
[    0.072437] 0 pages in swap cache
[    0.072438] Free swap  = 0kB
[    0.072439] Total swap = 0kB
[    0.072439] 4164634 pages RAM
[    0.072440] 0 pages HighMem/MovableOnly
[    0.072441] 126548 pages reserved
[    0.072441] 0 pages hwpoisoned
[    0.072443] Stack Depot hash table allocation failed, disabling
[    0.072465] Kernel/User page tables isolation: enabled

I hope you will take time to make an assessment of this notice despite me
not being an authority in the matters of the Linux kernel.

But you will easily see that this patch does not work without kmemleak=
boot param.

Kind regards,
Mirsad

-- 
Mirsad Todorovac
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb
Republic of Croatia, the European Union
--
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

