From: akpm@linux-foundation.org
Subject: [patch 07/16] zram: do not free pool->size_class
Date: Wed, 02 Aug 2017 13:32:03 -0700
Message-ID: <598236c3.ll4yCkT3URTW/ovz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbdHBUcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, efault@gmx.de, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

From: Minchan Kim <minchan@kernel.org>
Subject: zram: do not free pool->size_class

Mike reported kernel goes oops with ltp:zram03 testcase.

[ 1449.835161] zram: Added device: zram0
[ 1449.929981] zram0: detected capacity change from 0 to 107374182400
[ 1449.968583] BUG: unable to handle kernel paging request at 0000306d61727a77
[ 1449.975550] IP: zs_map_object+0xb9/0x260
[ 1449.979472] PGD 0
[ 1449.979473] P4D 0
[ 1449.981488]
[ 1449.984997] Oops: 0000 [#1] SMP
[ 1449.988139] Dumping ftrace buffer:
[ 1449.991545]    (ftrace buffer empty)
[ 1449.995120] Modules linked in: zram(E) xfs(E) libcrc32c(E) btrfs(E) xor(E) raid6_pq(E) loop(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) af_packet(E) br_netfilter(E) bridge(E) stp(E) llc(E) iscsi_ibft(E) iscsi_boot_sysfs(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) intel_powerclamp(E) coretemp(E) cdc_ether(E) kvm_intel(E) usbnet(E) mii(E) kvm(E) irqbypass(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) iTCO_wdt(E) ghash_clmulni_intel(E) bnx2(E) iTCO_vendor_support(E) pcbc(E) ioatdma(E) ipmi_ssif(E) aesni_intel(E) i5500_temp(E) i2c_i801(E) aes_x86_64(E) lpc_ich(E) shpchp(E) mfd_core(E) crypto_simd(E) i7core_edac(E) dca(E) glue_helper(E) cryptd(E) ipmi_si(E) button(E) acpi_cpufreq(E) ipmi_devintf(E) pcspkr(E) ipmi_m
 sghandler(E)
[ 1450.065731]  nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E) sunrpc(E) ext4(E) crc16(E) mbcache(E) jbd2(E) sd_mod(E) ata_generic(E) i2c_algo_bit(E) ata_piix(E) drm_kms_helper(E) ahci(E) syscopyarea(E) sysfillrect(E) libahci(E) sysimgblt(E) fb_sys_fops(E) uhci_hcd(E) ehci_pci(E) ttm(E) ehci_hcd(E) libata(E) drm(E) megaraid_sas(E) usbcore(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) efivarfs(E) autofs4(E) [last unloaded: zram]
[ 1450.107900] CPU: 6 PID: 12356 Comm: swapon Tainted: G            E   4.13.0.g87b2c3f-default #194
[ 1450.116760] Hardware name: IBM System x3550 M3 -[7944K3G]-/69Y5698     , BIOS -[D6E150AUS-1.10]- 12/15/2010
[ 1450.126486] task: ffff880158d2c4c0 task.stack: ffffc90001680000
[ 1450.132401] RIP: 0010:zs_map_object+0xb9/0x260
[ 1450.136843] RSP: 0018:ffffc90001683988 EFLAGS: 00010202
[ 1450.142063] RAX: 0000000000000000 RBX: ffff8801547a98d0 RCX: ffff8801211b78b0
[ 1450.149190] RDX: 0000306d61727a2f RSI: 0000000000160000 RDI: ffff8801547a98f8
[ 1450.156317] RBP: ffffc900016839c8 R08: 0000000004db4200 R09: 0000000000000008
[ 1450.163446] R10: ffff880151329260 R11: 0000000000000000 R12: ffff880158f76000
[ 1450.170573] R13: 0000000000000001 R14: 0000000000000000 R15: ffffea0004db4200
[ 1450.177700] FS:  00007fe1b4e8b880(0000) GS:ffff88017f180000(0000) knlGS:0000000000000000
[ 1450.185782] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1450.191522] CR2: 0000306d61727a77 CR3: 0000000154415000 CR4: 00000000000006e0
[ 1450.198649] Call Trace:
[ 1450.201103]  zram_bvec_rw.isra.26+0xe8/0x780 [zram]
[ 1450.205978]  zram_rw_page+0x6e/0xa0 [zram]
[ 1450.210077]  bdev_read_page+0x81/0xb0
[ 1450.213738]  do_mpage_readpage+0x51a/0x710
[ 1450.217837]  ? lru_cache_add+0xe/0x10
[ 1450.221498]  mpage_readpages+0x122/0x1a0
[ 1450.225420]  ? I_BDEV+0x20/0x20
[ 1450.228560]  ? I_BDEV+0x20/0x20
[ 1450.231702]  ? alloc_pages_current+0x6a/0xb0
[ 1450.235971]  blkdev_readpages+0x1d/0x20
[ 1450.239805]  __do_page_cache_readahead+0x1b2/0x270
[ 1450.244596]  ondemand_readahead+0x180/0x2c0
[ 1450.248777]  page_cache_sync_readahead+0x31/0x50
[ 1450.253394]  generic_file_read_iter+0x7e7/0xaf0
[ 1450.257922]  blkdev_read_iter+0x37/0x40
[ 1450.261756]  __vfs_read+0xce/0x140
[ 1450.265160]  vfs_read+0x9e/0x150
[ 1450.268389]  SyS_read+0x46/0xa0
[ 1450.271533]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[ 1450.276149] RIP: 0033:0x7fe1b4344270
[ 1450.279724] RSP: 002b:00007ffdb4299f48 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 1450.287287] RAX: ffffffffffffffda RBX: 00007fe1b4604678 RCX: 00007fe1b4344270
[ 1450.294414] RDX: 0000000000010000 RSI: 0000000000db2c00 RDI: 0000000000000006
[ 1450.301541] RBP: 00007fe1b4604620 R08: 0000000000000003 R09: 00007fe1b4604678
[ 1450.308667] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000010030
[ 1450.315794] R13: 0000000000010000 R14: 0000000000002710 R15: 0000000000010011
[ 1450.322920] Code: 81 e6 00 c0 3f 00 81 fe 00 00 16 00 0f 85 9f 01 00 00 0f b7 13 65 ff 05 5e 07 dc 7e 66 c1 ea 02 81 e2 ff 01 00 00 49 8b 54 d4 08 <8b> 4a 48 41 0f af ce 81 e1 ff 0f 00 00 41 89 c9 48 c7 c3 a0 70
[ 1450.341785] RIP: zs_map_object+0xb9/0x260 RSP: ffffc90001683988
[ 1450.347698] CR2: 0000306d61727a77

He bisected the problem is [1].

By cf8e0fedf078 ("mm/zsmalloc: simplify zs_max_alloc_size handling"), zram
doesn't use double pointer for pool->size_class any more in zs_create_pool
so counter function zs_destroy_pool don't need to free it, either. 
Otherwise, it does kfree wrong address and then, kernel goes Oops.

Link: http://lkml.kernel.org/r/20170725062650.GA12134@bbox
Fixes: cf8e0fedf078 ("mm/zsmalloc: simplify zs_max_alloc_size handling")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/zsmalloc.c~zram-do-not-free-pool-size_class mm/zsmalloc.c
--- a/mm/zsmalloc.c~zram-do-not-free-pool-size_class
+++ a/mm/zsmalloc.c
@@ -2453,7 +2453,6 @@ void zs_destroy_pool(struct zs_pool *poo
 	}
 
 	destroy_cache(pool);
-	kfree(pool->size_class);
 	kfree(pool->name);
 	kfree(pool);
 }
_
