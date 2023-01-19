Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB42C00A5A
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 17:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjASRB6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 12:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjASRB4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 12:01:56 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA447EE0
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 09:01:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 5ECE8604F7;
        Thu, 19 Jan 2023 18:01:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1674147710; bh=2lIVJ7J7gpPzDt2lpezUW5QJboRAh89HXOd9kuV1tEY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eJZ41Rwyw4pdwg+V/XY+Jov+Dn+NznprbZBBQXiXWhF7aaPvoLSgg9GQddkp5IPp/
         nW1dAuRbQdsym5OunAUwDnsfcK80m7DfVeZPOltr2S80Km8O1qK0RSSIhbXJ7ETZIS
         R7vu5Pv8Zjm2YcAVM2Jj/hg5ALng7aYUhD+IA2hvtxgkO/bm4FsZNsFRMfoH0gjt4S
         x02byjfg4jJ4RhBkBV1Rru4pPUzNpFMhcvq/Mwro0fbZttLNdXp6MimRW0ISVxtLZ5
         1d1ODe9MrWymCRJV7fqCZbXO8e4VmfoO77S7mQU8artqYFQMzFGF8oHifXbAcdhTIN
         dBPZKJrmPYJpw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lk9D3eZDoROJ; Thu, 19 Jan 2023 18:01:47 +0100 (CET)
Received: from [161.53.83.51] (pc-mtodorov.grf.hr [161.53.83.51])
        by domac.alu.hr (Postfix) with ESMTPSA id 530AA604F0;
        Thu, 19 Jan 2023 18:01:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1674147707; bh=2lIVJ7J7gpPzDt2lpezUW5QJboRAh89HXOd9kuV1tEY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Y+PaJKal7o5M88bQ5Owbycs2netLHivuPzeVDBSvY6eSCvwm5k54WUm7J/2xjudxy
         2kXEc//n0LtmY67/W8b08oAKjKaKZCxrSlN+KmG46ANWqz73KClQclYz/pxdS8NpdS
         4BkPW9+OaCTm+TcbR1GVjEPhrrilcg5TTzWFnK28pf0ggU2mIk2S6eL1kIWR58+UsX
         Dw54iNtsKfhMpBPL278mfdcE8/tbKr+WmlMYQmgAT8Vyw2BvpD3LFLFaghL3C3e29y
         sFLNlH1fzaT2S89y6ih7/Vydo1TVwMsAC75Ws3b7i5NKFXbmPf0fUcUrL1U7nxGq9X
         V+LAjtvIm1PFA==
Message-ID: <14035fe0-6ac2-fa30-875c-3a52677f5c00@alu.unizg.hr>
Date:   Thu, 19 Jan 2023 18:01:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: + mm-use-stack_depot_early_init-for-kmemleak.patch added to
 mm-hotfixes-unstable branch
Content-Language: en-US
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        nathan@kernel.org, ke.wang@unisoc.com, huangzhaoyang@gmail.com,
        zhaoyang.huang@unisoc.com
References: <20230118001933.5E38DC433F1@smtp.kernel.org>
 <a6ff1869-d90e-3d3c-b023-3a95b4bc7eaf@alu.unizg.hr>
 <Y8lWUVIcOasoLYEZ@arm.com>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <Y8lWUVIcOasoLYEZ@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 19.1.2023. 15:40, Catalin Marinas wrote:
> On Thu, Jan 19, 2023 at 02:02:29PM +0100, Mirsad Goran Todorovac wrote:
>> On 18.1.2023. 1:19, Andrew Morton wrote:
>>> --- a/mm/kmemleak.c~mm-use-stack_depot_early_init-for-kmemleak
>>> +++ a/mm/kmemleak.c
>>> @@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(c
>>>    		return -EINVAL;
>>>    	if (strcmp(str, "off") == 0)
>>>    		kmemleak_disable();
>>> -	else if (strcmp(str, "on") == 0)
>>> +	else if (strcmp(str, "on") == 0) {
>>>    		kmemleak_skip_disable = 1;
>>> +		stack_depot_want_early_init();
>>> +	}
>>>    	else
>>>    		return -EINVAL;
>>>    	return 0;
>>> _
>>>
>>> Patches currently in -mm which might be from zhaoyang.huang@unisoc.com are
>>>
>>> mm-use-stack_depot_early_init-for-kmemleak.patch
>>
>> Please note that this patch activates stack_depot_want_early_init() only when
>> kernel boot param "kmemleak=on" is used.
>>
>> When the following configuration is used:
>>
>> CONFIG_HAVE_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
>> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
>> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
> 
> Indeed, I commented here already:
> 
> https://lore.kernel.org/all/Y8gDdnpvkCKvVV1t@arm.com/

Hi,

I can report that the test was successful w/o kmemleak boot param.
As it is evident from the command output, /sys/kernel/debug/kmemleak
backtrace is now whole again:

dmesg:
[    0.033071] Kernel command line: BOOT_IMAGE=(hd0,gpt5)/vmlinuz-6.2.0-rc4-mglru-kmemlk-patch-zhaoyang5+ 
root=/dev/mapper/almalinux_desktop--mtodorov-root ro crashkernel=auto resume=/dev/mapper/almalinux_desktop--mtodorov-swap 
rd.lvm.lv=almalinux_desktop-mtodorov/root rd.lvm.lv=almalinux_desktop-mtodorov/swap loglevel=7 i915.alpha_support=1
[    0.033221] Unknown kernel command line parameters "BOOT_IMAGE=(hd0,gpt5)/vmlinuz-6.2.0-rc4-mglru-kmemlk-patch-zhaoyang5+", will 
be passed to user space.
[    0.034024] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.034403] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.034500] mem auto-init: stack:off, heap alloc:on, heap free:off
[    0.034901] stackdepot hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.034910] software IO TLB: area num 8.
[    0.072568] Memory: 16143436K/16658536K available (18432K kernel code, 4118K rwdata, 7184K rodata, 4424K init, 7680K bss, 514840K 
reserved, 0K cma-reserved)
[    0.072753] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.072775] Kernel/User page tables isolation: enabled

[root@pc-mtodorov marvin]# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff948246489b00 (size 16):
   comm "kworker/u12:5", pid 349, jiffies 4294893879 (age 87.016s)
   hex dump (first 16 bytes):
     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
   backtrace:
     [<ffffffff899cb9f1>] slab_post_alloc_hook+0x91/0x320
     [<ffffffff899d1faf>] __kmem_cache_alloc_node+0x1bf/0x2b0
     [<ffffffff8994fbb5>] __kmalloc_node_track_caller+0x55/0x140
     [<ffffffff89940b96>] kstrdup+0x36/0x70
     [<ffffffff89940c08>] kstrdup_const+0x28/0x30
     [<ffffffff89cfc348>] kvasprintf_const+0x78/0xa0
     [<ffffffff8a48a903>] kobject_set_name_vargs+0x23/0xa0
     [<ffffffff89fba2b3>] dev_set_name+0x53/0x70
     [<ffffffffc0e4dd3f>] memstick_check+0xff/0x384 [memstick]
     [<ffffffff896f6054>] process_one_work+0x214/0x3f0
     [<ffffffff896f6274>] worker_thread+0x34/0x3d0
     [<ffffffff897003cd>] kthread+0xed/0x120
     [<ffffffff896039f9>] ret_from_fork+0x29/0x50
unreferenced object 0xffff948246489c70 (size 16):
   comm "kworker/u12:5", pid 349, jiffies 4294893882 (age 87.004s)
   hex dump (first 16 bytes):
     6d 65 6d 73 74 69 63 6b 30 00 00 00 00 00 00 00  memstick0.......
   backtrace:
     [<ffffffff899cb9f1>] slab_post_alloc_hook+0x91/0x320
     [<ffffffff899d1faf>] __kmem_cache_alloc_node+0x1bf/0x2b0
     [<ffffffff8994fbb5>] __kmalloc_node_track_caller+0x55/0x140
     [<ffffffff89940b96>] kstrdup+0x36/0x70
     [<ffffffff89940c08>] kstrdup_const+0x28/0x30
     [<ffffffff89cfc348>] kvasprintf_const+0x78/0xa0
     [<ffffffff8a48a903>] kobject_set_name_vargs+0x23/0xa0
     [<ffffffff89fba2b3>] dev_set_name+0x53/0x70
     [<ffffffffc0e4dd3f>] memstick_check+0xff/0x384 [memstick]
     [<ffffffff896f6054>] process_one_work+0x214/0x3f0
     [<ffffffff896f6274>] worker_thread+0x34/0x3d0
     [<ffffffff897003cd>] kthread+0xed/0x120
     [<ffffffff896039f9>] ret_from_fork+0x29/0x50
[root@pc-mtodorov marvin]# grep KMEMLEAK /boot/config-6.2.0-rc4-mglru-kmemlk-patch-zhaoyang5+
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
[root@pc-mtodorov marvin]#

I have used mainline torvalds tree vanilla kernel w MGLRU and KMEMLEAK
settings as above and the diff as below:

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 881c3f84e88a..ddbfac2adf9c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -743,76 +743,6 @@ config SHRINKER_DEBUG
           visibility into the kernel memory shrinkers subsystem.
           Disable it to avoid an extra memory footprint.

-config HAVE_DEBUG_KMEMLEAK
-       bool
-
-config DEBUG_KMEMLEAK
-       bool "Kernel memory leak detector"
-       depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
-       select DEBUG_FS
-       select STACKTRACE if STACKTRACE_SUPPORT
-       select KALLSYMS
-       select CRC32
-       select STACKDEPOT
-       help
-         Say Y here if you want to enable the memory leak
-         detector. The memory allocation/freeing is traced in a way
-         similar to the Boehm's conservative garbage collector, the
-         difference being that the orphan objects are not freed but
-         only shown in /sys/kernel/debug/kmemleak. Enabling this
-         feature will introduce an overhead to memory
-         allocations. See Documentation/dev-tools/kmemleak.rst for more
-         details.
-
-         Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
-         of finding leaks due to the slab objects poisoning.
-
-         In order to access the kmemleak file, debugfs needs to be
-         mounted (usually at /sys/kernel/debug).
-
-config DEBUG_KMEMLEAK_MEM_POOL_SIZE
-       int "Kmemleak memory pool size"
-       depends on DEBUG_KMEMLEAK
-       range 200 1000000
-       default 16000
-       help
-         Kmemleak must track all the memory allocations to avoid
-         reporting false positives. Since memory may be allocated or
-         freed before kmemleak is fully initialised, use a static pool
-         of metadata objects to track such callbacks. After kmemleak is
-         fully initialised, this memory pool acts as an emergency one
-         if slab allocations fail.
-
-config DEBUG_KMEMLEAK_TEST
-       tristate "Simple test for the kernel memory leak detector"
-       depends on DEBUG_KMEMLEAK && m
-       help
-         This option enables a module that explicitly leaks memory.
-
-         If unsure, say N.
-
-config DEBUG_KMEMLEAK_DEFAULT_OFF
-       bool "Default kmemleak to off"
-       depends on DEBUG_KMEMLEAK
-       help
-         Say Y here to disable kmemleak by default. It can then be enabled
-         on the command line via kmemleak=on.
-
-config DEBUG_KMEMLEAK_AUTO_SCAN
-       bool "Enable kmemleak auto scan thread on boot up"
-       default y
-       depends on DEBUG_KMEMLEAK
-       help
-         Depending on the cpu, kmemleak scan may be cpu intensive and can
-         stall user tasks at times. This option enables/disables automatic
-         kmemleak scan at boot up.
-
-         Say N here to disable kmemleak auto scan thread to stop automatic
-         scanning. Disabling this option disables automatic reporting of
-         memory leaks.
-
-         If unsure, say Y.
-
  config DEBUG_STACK_USAGE
         bool "Stack utilization instrumentation"
         depends on DEBUG_KERNEL && !IA64
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index fca699ad1fb0..f765f4769f39 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -207,3 +207,74 @@ config PTDUMP_DEBUGFS
           kernel.

           If in doubt, say N.
+
+config HAVE_DEBUG_KMEMLEAK
+       bool
+
+config DEBUG_KMEMLEAK
+       bool "Kernel memory leak detector"
+       depends on DEBUG_KERNEL && HAVE_DEBUG_KMEMLEAK
+       select DEBUG_FS
+       select STACKTRACE if STACKTRACE_SUPPORT
+       select KALLSYMS
+       select CRC32
+       select STACKDEPOT
+       select STACKDEPOT_ALWAYS_INIT if !DEBUG_KMEMLEAK_DEFAULT_OFF
+       help
+         Say Y here if you want to enable the memory leak
+         detector. The memory allocation/freeing is traced in a way
+         similar to the Boehm's conservative garbage collector, the
+         difference being that the orphan objects are not freed but
+         only shown in /sys/kernel/debug/kmemleak. Enabling this
+         feature will introduce an overhead to memory
+         allocations. See Documentation/dev-tools/kmemleak.rst for more
+         details.
+
+         Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
+         of finding leaks due to the slab objects poisoning.
+
+         In order to access the kmemleak file, debugfs needs to be
+         mounted (usually at /sys/kernel/debug).
+
+config DEBUG_KMEMLEAK_MEM_POOL_SIZE
+       int "Kmemleak memory pool size"
+       depends on DEBUG_KMEMLEAK
+       range 200 1000000
+       default 16000
+       help
+         Kmemleak must track all the memory allocations to avoid
+         reporting false positives. Since memory may be allocated or
+         freed before kmemleak is fully initialised, use a static pool
+         of metadata objects to track such callbacks. After kmemleak is
+         fully initialised, this memory pool acts as an emergency one
+         if slab allocations fail.
+
+config DEBUG_KMEMLEAK_TEST
+       tristate "Simple test for the kernel memory leak detector"
+       depends on DEBUG_KMEMLEAK && m
+       help
+         This option enables a module that explicitly leaks memory.
+
+         If unsure, say N.
+
+config DEBUG_KMEMLEAK_DEFAULT_OFF
+       bool "Default kmemleak to off"
+       depends on DEBUG_KMEMLEAK
+       help
+         Say Y here to disable kmemleak by default. It can then be enabled
+         on the command line via kmemleak=on.
+
+config DEBUG_KMEMLEAK_AUTO_SCAN
+       bool "Enable kmemleak auto scan thread on boot up"
+       default y
+       depends on DEBUG_KMEMLEAK
+       help
+         Depending on the cpu, kmemleak scan may be cpu intensive and can
+         stall user tasks at times. This option enables/disables automatic
+         kmemleak scan at boot up.
+
+         Say N here to disable kmemleak auto scan thread to stop automatic
+         scanning. Disabling this option disables automatic reporting of
+         memory leaks.
+
+         If unsure, say Y.
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 92f670edbf51..5082e02b6c2d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2070,8 +2070,10 @@ static int __init kmemleak_boot_config(char *str)
                 return -EINVAL;
         if (strcmp(str, "off") == 0)
                 kmemleak_disable();
-       else if (strcmp(str, "on") == 0)
+       else if (strcmp(str, "on") == 0) {
                 kmemleak_skip_disable = 1;
+               stack_depot_want_early_init();
+       }
         else
                 return -EINVAL;
         return 0;
@@ -2093,7 +2095,6 @@ void __init kmemleak_init(void)
         if (kmemleak_error)
                 return;

-       stack_depot_init();
         jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
         jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);

Please check if the above is correct.

Hope this helps, as this is the environment that triggered the vmalloc()
but. But I would like to go into depth, we have allocated stack_init_depot
early, but I can't seem to realise why the initial kvmalloc() failed?

Could this possibly be a sign of another bug, or was it simply called too
early, before mm_init()?

I am sorry if this is a stupid question.

Regards,
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

