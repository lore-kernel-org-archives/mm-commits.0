From: akpm@linux-foundation.org
Subject: - git-qla3xxx.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:27:32 -0700
Message-ID: <200708250327.l7P3RWFg028143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53301 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbXHYDd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, Larry.Finger@lwfinger.net, aabdulla@nvidia.com, akinobu.mita@gmail.com, akpm@linux-foundation.org, arjan@linux.intel.com, arnd@arndb.de, auke-jan.h.kok@intel.com


The patch titled
     git-qla3xxx.patch
has been removed from the -mm tree.  Its filename was
     git-qla3xxx.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-qla3xxx.patch

GIT 9259378d56a748a77f2defc9add87baa797652ce git://electric-eye.fr.zoreil.com/home/romieu/linux-2.6.git#qla3xxx

commit 
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Jan 10 23:26:51 2007 +0100

    qla3xxx: more unsigned int and reduction of the scope of local variables
    
    - removed a few useless as well (addrBits/dataBits adn forward declaration
      of fm93c56a_deselect/eeprom_readword) ;
    - ql_process_mac_tx_intr: more unmapping work is done in the loop to
      reduce the code ;
    - ql_tx_rx_clean: use the existing local alias for qdev->nedv ;
    - ql3xxx_send: ugly.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit e739a9001c90f3f4d0c80774a91525d00a8cda6b
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Jan 10 22:19:54 2007 +0100

    qla3xxx: curly braces and line breaks
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 8045325e37834e7046812712af405dcdec08baab
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Dec 27 21:27:24 2006 +0100

    qla3xxx: propagate the return status of ql_sem_spinlock
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 93df39d05d84ec96e6e00b80ed902db2d748256b
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 15:17:49 2006 +0100

    qla3xxx: trim #include list
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 8033e92bfb8bf1c6bfcdd9579ac414a35718dab3
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 15:13:59 2006 +0100

    qla3xxx: minor ql3xxx_probe changes
    
    - ql_display_dev_info
      - display driver and device name on each line.
    - ql3xxx_probe
      - remove unneeded initializations
      - ql3_adapter.index is almost useless. Use ql_version_printed instead
      - error path review. No problem.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit d88b86ca28a1beddb9be9bbbb35eebd87ad426b5
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 14:56:03 2006 +0100

    qla3xxx: factor out ql_write_page[012]_reg
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 388ecd6a90be9776ed1421c806be90dfa2cb41f2
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 14:52:49 2006 +0100

    qla3xxx: prettify ql_populate_free_queue
    
    It is shorter too.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 57bd9cac1277251a7f3f9e51d9847b2828d41041
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 14:44:47 2006 +0100

    qla3xxx: parenthesis diet
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 38d17afa5d83990c56462b35c59d77decabc6388
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 13:56:51 2006 +0100

    qla3xxx: add local variables to access the registers
    
    It makes the code shorter and helps with indentation.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 289d9c4276b7c336d267618fdc584dfc3ed9a563
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Thu Dec 21 18:57:16 2006 +0100

    qla3xxx: add/remove spaces (codingstyle)
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 95a5ce52bb4e6caa6a329d6c1932e872d09a0883
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Thu Dec 21 15:06:18 2006 +0100

    qla3xxx: remove return statements in void returning functions

commit 13891170bb2f1991f855b35618135071ed856b79
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 13:11:39 2006 +0100

    qla3xxx: rename 'mem_map_registers' to 'ioaddr'
    
    It is just the usual netdev ioremaped area.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit f318acb27f1b06f142e90cd6a10c03d5afff6442
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Thu Sep 28 23:01:12 2006 +0200

    qla3xxx: remove unused field in struct ql3_adapter
    
    The symbol does not appear in the whole kernel sources nor does
    it prevent the driver to compile.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit b2d2515833bacb1c87a70865d7e6fe95511fffeb
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 13:06:51 2006 +0100

    qla3xxx: rename 'hw_flags' to 'flags' for use with spinlock (cosmetic)
    
    Idiom.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 71100d83e41222b10549c05cf68be5e506740829
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Fri Dec 22 13:05:26 2006 +0100

    qla3xxx: prettify ql_reset_work()
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 998367551f16e7fefb0d7b7f891fa5e83f2f068b
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Dec 20 22:42:46 2006 +0100

    qla3xxx: de-obfuscate ql_wait_for_drvr_lock()
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit fa5ce7b0c40f2a12bfe026eff5694fc014345a27
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Sep 26 00:21:22 2006 +0200

    qla3xxx: tab/space and duplicate variable
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 7224518e4ec7206db7f9d1cf303c185ee43c53e9
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Dec 20 22:34:14 2006 +0100

    qla3xxx: remove cast to void *
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit f9441bdea9fa1dbd4efb2595caa31f8c6aec1f92
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Sep 26 00:21:22 2006 +0200

    qla3xxx: comment broken ssleep
    
    They are issued with spinlock held.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 28a5a10068c0e5d1de47b6e2ff4cc9507311e926
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Dec 20 22:27:50 2006 +0100

    qla3xxx: netdev_priv() use and duplicate initialization
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit a3cdde0d4cca9f5d392ab9ec53720b5be6a936b1
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Wed Dec 20 22:26:38 2006 +0100

    qla3xxx: needless casts
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit a0b8ed4f168a604001ee492468c79c20edfac2f4
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 23 12:27:21 2007 -0500

    forcedeth: statistics optimization
    
    This patch optimizes the data paths that can support hw counters. It
    removes the sw counted statistics.
    
    This is the last patch for the optimization set. Bumping up version of
    driver.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 9d0a6e3d18d19fd44232c2aa876f60a17c7a81bb
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 23 12:27:00 2007 -0500

    forcedeth: statistics supported
    
    This patch introduces hw statistics for older devices that supported it.
    It breaks up the counters supported into separate versions.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 4ffc5e20dae5f59bcd5ad4d9b6dc558f458fa348
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 23 12:00:56 2007 -0500

    forcedeth: tx max work
    
    This patch adds a limit to how much tx work can be done in each
    iteration of tx processing. If the max limit is reached, remaining tx
    completions will be handled by timer interrupt.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit a5fa5e328116303d92c69f6724e69b664d10e480
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Sun Jan 21 18:10:57 2007 -0500

    forcedeth: irq data path optimization
    
    This patch optimizes the irq data paths and cleans up the code.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 721c8d1944f87b8f5ce88a123f680dfca5138ace
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Sun Jan 21 18:10:52 2007 -0500

    forcedeth: rx data path optimization
    
    This patch optimizes the rx data paths and cleans up the code.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 2b640425edd030dffb0cb030df1c03e9b832b1b8
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Sun Jan 21 18:10:47 2007 -0500

    forcedeth: tx data path optimization
    
    This patch optimizes the tx data paths and cleans up the code (removes
    vlan from descr1/2 since only valid for desc3, changes to make code
    easier to read, etc).
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit eacfe63d474b233dc9184113860f318e695d9684
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Sun Jan 21 18:10:42 2007 -0500

    forcedeth: tx limiting
    
    This patch optimizes the logic for tx limiting. It adds a flag to check
    on the completion side instead of recalculating the number of empty
    slots. Also, it removes the fields that were previous used for limiting
    since they have no value.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit f3ad98e208fd87fa846d7ce969295ec015af8040
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Sun Jan 21 18:10:37 2007 -0500

    forcedeth: optimized routines
    
    This patch breaks up the routines into two versions, one for legacy
    descriptor versions (ver 1 and ver 2) and one for desc ver 3. This will
    make the new desc functions more leaner and further reductions will be
    made in next few patches.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit d779011a049ee0517f45416859b5c0967bae5120
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Fri Jan 19 18:15:56 2007 -0800

    bonding: update version
    
    	Update version number to reflect recent changes.
    
    Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 49aef8e07ef782f86d396b891393621559654a15
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Fri Jan 19 18:15:47 2007 -0800

    bonding: modify sysfs support to permit multiple loads
    
    	The existing code would blindly attempt to create the
    bonding_masters file (in /sys/class/net) every time the module was
    loaded.  When the module is loaded multiple times (which is the
    historical method used by initscripts and sysconfig to create multiple
    bonding interfaces), this caused load failure of the second module load
    attempt, as the creation request would fail.
    
    	This changes the code to note the failure, arrange to not remove
    the bonding_masters file upon module exit, and then return success.
    
    	Bonding interfaces created by the second or subsequent loads of
    the module will not exist in bonding_masters.  This is not a significant
    change, as previously only the interfaces from the most recent load of
    the module would be listed.  Both situations are less than optimal, but
    this case permits compatibility with existing distro configuration
    scripts, and is consistent.
    
    	Note that previously, the sysfs create request would overwrite
    the exsting bonding_masters file and succeed, allowing multiple loads of
    the module.  The sysfs code has recently changed to return an error if
    the file being created already exists.
    
    	Patrick McHardy <kaber@trash.net>, who reported this problem,
    observed crashes on the old kernel (before sysfs checked for
    duplicates).  I did not experience such crashes, but this change should
    resolve them.
    
    Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 1af69a5feafcd7e16ad7e5869bfd2bfcc0e4b23a
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Fri Jan 19 18:15:38 2007 -0800

    bonding: fix error check in sysfs creation
    
    	The existing code did not correctly handle failures to create
    the per-interface sysfs group for bonding.
    
    	Modified code to notice errors, and correctly unwind.
    
    Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 22246909fec07f5affc8af2c2eda7be448a907f9
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Fri Jan 19 18:15:31 2007 -0800

    bonding: fix device name allocation error
    
    	The code to select names for the bonding interfaces was, for the
    non-sysfs creation case, always using a hard-coded set of bond0, bond1,
    etc, up to max_bonds.  This caused conflicts for the second or
    subsequent loads of the module.
    
    	Changed the code to obtain device names from dev_alloc_name().
    
    Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 9feb340365737644f5109ccd13e66011864e5ef1
Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue Dec 19 13:09:08 2006 -0800

    net: use bitrev8
    
    Use bitrev8 for bmac, mace, macmace, macsonic, and skfp drivers.
    
    [akpm@osdl.org: use the API, not the array]
    Cc: Jeff Garzik <jgarzik@pobox.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Mirko Lindner <mlindner@syskonnect.de>
    Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 6cc93a6467682a3c35035166d6e71ee4572adce4
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Dec 12 17:24:39 2006 +0100

    bonding.h: "extern inline" -> "static inline"
    
    "extern inline" generates a warning with -Wmissing-prototypes and I'm
    currently working on getting the kernel cleaned up for adding this to
    the CFLAGS since it will help us to avoid a nasty class of runtime
    errors.
    
    If there are places that really need a forced inline, __always_inline
    would be the correct solution.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 5961daba283e401cb69be9621ea4cb677edcf560
Author: Ron Mercer <ron.mercer@qlogic.com>
Date:   Wed Jan 3 16:26:08 2007 -0800

    qla3xxx: Add support for Qlogic 4032 chip.
    
    Qlogic 4032 chip is an incremental change from the 4022.
    Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 9c2a1a01bbdcc7f7c516f24f86d6d607cd4388e5
Author: Adrian Bunk <bunk@stusta.de>
Date:   Thu Jan 4 19:53:30 2007 +0100

    remove the broken OAKNET driver
    
    The OAKNET driver:
    - has been marked as BROKEN for more than two years and
    - is still marked as BROKEN.
    
    Drivers that had been marked as BROKEN for such a long time seem to be
    unlikely to be revived in the forseeable future.
    
    But if anyone wants to ever revive this driver, the code is still
    present in the older kernel releases.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit f14d50be0f7616b58211602d961e200319d80a01
Author: Stephen Hemminger <shemminger@osdl.org>
Date:   Mon Jan 8 11:26:12 2007 -0800

    chelsio: more rx speedup
    
    Cleanup receive processing some more:
       * do the reserve padding of skb during setup
       * don't pass constants to get_packet
       * do smart prefetch of skb
       * make copybreak a module parameter
    
    Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit bd1d1aec84dc17d2fb4fc9e8a28412aff58b550b
Author: Stephen Hemminger <shemminger@osdl.org>
Date:   Mon Jan 8 11:26:30 2007 -0800

    chelsio: NAPI speed improvement
    
    Speedup and cleanup the receive processing by eliminating the
    mmio read and a lock round trip.
    
    Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 261216b8aa621f6c56042105f1347fc6a5a4bd17
Author: Divy Le Ray <divy@chelsio.com>
Date:   Thu Jan 18 22:04:14 2007 -0500

    Add support for the latest 1G/10G Chelsio adapter, T3.
    
    This driver is required by the Chelsio T3 RDMA driver posted by
    Steve Wise.
    
    Signed-off-by: Divy Le Ray <divy@chelsio.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 223710f251320ae94a9fd615b3347c752c9af29a
Author: Adrian Bunk <bunk@stusta.de>
Date:   Thu Jan 11 14:48:59 2007 +0100

    make hdlc_setup() static again
    
    hdlc_setup was exported, but this export was never used.
    
    If a driver using it actually shows up it can still be exported again.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 5010d46975f8ffb3886214ba6862bad02ad991bb
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 9 13:30:13 2007 -0500

    forcedeth: rx skb recycle
    
    This patch removes the code that recycled the skb on error. This will
    help in reducing the branches in the main data paths.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 8d08857b3ba8831d88910b221cb23d3563d95415
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 9 13:30:10 2007 -0500

    forcedeth: tx locking
    
    This patch reduces the amount of code within the lock to only the
    critical sections.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit ffaa0476174e05ff70771cc462fa75ccff0fdd97
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 9 13:30:07 2007 -0500

    forcedeth: ring access
    
    This patch modifys ring access by using pointers. This avoids computing
    the current index and avoids accessing the base address of the rings.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit de96d74156d7b9c937bb4a2ff668eb952e0d48eb
Author: Ayaz Abdulla <aabdulla@nvidia.com>
Date:   Tue Jan 9 13:30:02 2007 -0500

    forcedeth: dma access
    
    This patch allows the hardware to fetch the tx and rx ring descriptors
    with 64 bytes per access instead of 32 bytes.
    
    Signed-Off-By: Ayaz Abdulla <aabdulla@nvidia.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 920d9a58b26998e4fcc883f5a7af2b9770c85ed2
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Dec 19 13:08:48 2006 -0800

    remove the broken SKMC driver
    
    The SKMC driver has:
    - already been marked as BROKEN in 2.6.0 three years ago and
    - is still marked as BROKEN.
    
    Drivers that had been marked as BROKEN for such a long time seem to be
    unlikely to be revived in the forseeable future.
    
    But if anyone wants to ever revive this driver, the code is still
    present in the older kernel releases.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 43ace47fed244f9ea91eb60ca4f25eb3c8e3b777
Author: Cesar Eduardo Barros <cesarb@cesarb.net>
Date:   Tue Dec 19 13:08:47 2006 -0800

    driver for Silan SC92031 netdev
    
    This is a driver for the Silan SC92031/Rsltek 8139D NIC chip.
    
    This chip is found on at least one counterfeit Encore ENL832-TX-RENT NIC
    [1], which came with a mini-CD with the 2.4 driver.  A slightly older
    version of the driver was found at [2].  The main difference between them
    is that the newer one has a small bugfix in the RX path, a lot of
    gratuitous renaming of functions, all the printable strings changed to show
    as a "Rsltek 8139D" [sic], and a PCI ID of 8139 instead of 2031.  The
    driver on this patch is a rewrite of the vendor drivers (based mostly on
    the older one).
    
    Changes from the previous patch sent to netdev:
    - Use MMIO instead of PIO
    - Changed TX bounce buffers allocation
    - Use skb_copy_and_csum_dev
    - Several small bug fixes
    - Tested for more than just a few minutes each time
    
    [1] See http://www.encore-usa.com/faq.php under ENL832-TX-RENT for more
        information
    [2] Look for SL_LINUX.ZIP (which is really a .tar.gz) at
        http://broadbandforum.in/dataone_Intex_LAN_cardlinux-t4207-s15.html
    [3] To compile on 2.6.17, simply add back the last argument to the
        interrupt handler in two places, and copy the boolean declarations
        from 2.6.19
    
    [akpm@osdl.org: build fixes]
    Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit e41fb7e3f1cd5c7b15835c461e654aa5b118b892
Author: Stephen Hemminger <shemminger@osdl.org>
Date:   Wed Dec 20 13:06:36 2006 -0800

    sky2: better power state management
    
    Improve power management and error handling by using pci_set_power_state(),
    instead of driver doing PCI PM register changes in the driver.
    
    Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 864ebf5a302c4f4f085cc1ee3a2f9cbc74b2e7d6
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Tue Dec 12 14:06:23 2006 +0100

    remove NETIF_F_TSO ifdefery
    
    Remove the NETIF_F_TSO #ifdef-ery in drivers/net; this was
    for old-old-2.4 compat (even current 2.4 has NETIF_F_TSO)
    but it's time to get rid of it by now.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 6fb58c1a7c54ee7a0d7749d71ce6161d4e1c46e9
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:23:56 2006 -0600

    Spidernet RX Debugging printout
    
    Add some debugging and error printing.
    
    The show_rx_chain() prints out the status of the rx chain,
    which shows that the status of the descriptors gets
    messed up after the second & subsequent RX ramfulls.
    
    Print out contents of bad packets if error occurs.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 7f9a83d20620de2d2a03cb8b97b6e3964f146ee2
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:23:01 2006 -0600

    Spidernet Avoid possible RX chain corruption
    
    Delete possible source of chain corruption; the hardware
    already knows the location of the tail, and writing it
    again is likely to mess it up.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit fb4cc3d766d30cc930802f07313e62175d2cf650
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:22:04 2006 -0600

    Spidernet Memory barrier
    
    Add memory barrier to make sure that the rest of the
    RX descriptor state is flushed to memory before we tell
    the hardware that its ready to go.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit c213916885ec16bf5fd6a2a5022d448425bfab50
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:20:59 2006 -0600

    Spidernet RX Chain tail
    
    Tell the hardware the location of the rx ring tail.
    More punctuation cleanup.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit a38acdd325823ef4a30f4425990edd2c8125de1e
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:19:54 2006 -0600

    Spidernet Remove unused variable
    
    Remove unused variable; this makes code easier to read.
    Tweak commentary.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 46adec79a47c6e94ea1d81f0e87ecd0d9c9d1f6a
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:18:52 2006 -0600

    Spidernet RX Refill
    
    The invocation of the rx ring refill routine is haphazard,
    it can be called from a central location.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 6aa64833c3d16bf1aed52e7833021da4fa4ae1bc
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:17:39 2006 -0600

    Spidernet Cleanup return codes
    
    Simplify the somewhat convoluted use of return codes
    in the rx buffer handling.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 21577516a78f5aad4ab540507f9724c599e9304e
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:16:18 2006 -0600

    Spidernet another skb mem leak
    
    Another skb leak in an error branch. Fix this by adding
    call to dev_kfree_skb_irq() after moving to a more
    appropriate spot.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 5b5c9879babf5e449fda42b949443d96266c9078
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:15:15 2006 -0600

    Spidernet RX skb mem leak
    
    One of the unlikely error branches has an skb memory leak.
    Fix this by handling the error conditions consistently.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 2918e808e1f2b8a9c300eeea3883e15d83d32239
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:12:26 2006 -0600

    Spidernet cleanup un-needed API
    
    There is no need to pass a flag into spider_net_decode_one_descr()
    so remove this, and perform some othre minor cleanup.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit c81e5ff514d45c45b676f32c4e6c5edd138b0f54
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:10:06 2006 -0600

    Spidernet remove rxramfull tasklet
    
    Get rid of the rxramfull tasklet, and let the NAPI poll routine
    deal with this situation. (The rxramfull interrupt is simply
    stating that the h/w has run out of room for incoming packets).
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit f933191df94afbc73f35c3a252d7b12f3512e6eb
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:08:25 2006 -0600

    Spidernet add net_ratelimit to suppress long output
    
    This patch adds net_ratelimit to many of the printks in order to
    limit extraneous warning messages (created in response to Bug 28554).
    This patch supercedes all previous ratelimit patches.
    This has been tested, please apply.
    
    From: James K Lewis <jklewis@us.ibm.com>
    Signed-off-by: James K Lewis <jklewis@us.ibm.com>
    Signed-off-by: Linas Vepstas <jlinas@austin.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 3ce646555f15e09b5382a494c6b7659520bffefa
Author: Linas Vepstas <linas@austin.ibm.com>
Date:   Wed Dec 13 15:06:59 2006 -0600

    Spidernet DMA coalescing
    
    The current driver code performs 512 DMA mappings of a bunch of
    32-byte ring descriptor structures. This is silly, as they are
    all in contiguous memory. This patch changes the code to
    dma_map_coherent() each rx/tx ring as a whole.
    
    Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
    Cc: James K Lewis <jklewis@us.ibm.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 5551368c4296e1e922a7a36fa01d1e609a381279
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 12 00:13:48 2006 +0100

    chelsio: tabulate the update of the statistic counters
    
    Let's try to avoid some code duplication.
    
    - cxgb2
      The data are contiguous. Use plain memcpy.
    
    - ixf1010/pm3393/vsc7326
      The cast of &mac->stats to (u64 *) is not wonderful but it is not clear
      if it is worth to add an ad-hoc union under the struct cmac_statistics.
    
    vsc7326_reg.h suggests that more statistics could be available.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 57967e328977f85c66301ddf7153c5e64f60f646
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 5 23:57:41 2006 +0100

    chelsio: misc cleanups in sge
    
    - duplicated code in sge::free_cmdQ_buffers ;
    - NET_IP_ALIGN is already defined in (included) <linux/skbuff.h> ;
    - pci_alloc_consistent() returns void * ;
    - pci_alloc_consistent() returns a zeroed chunk of memory ;
    - early return in restart_tx_queues.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit c3f310c0567c0e8537c9b9000a05f48dfcc9c1e9
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 5 23:19:06 2006 +0100

    chelsio: useless test in cxgb2::remove_one
    
    pci_get_drvadata() is necessarily distinct from NULL if
    cxgb2::init_one succeeded. cxgb2::remove_one is solely
    issued through the PCI device callback.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 59d058d9408b76e4a2f92286e1d3a947d4d4eb4f
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Mon Dec 11 23:49:13 2006 +0100

    chelsio: useless curly braces
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit f4e7aa0ab306c99f4f9f139573798be4bbe62d05
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Mon Dec 11 23:47:00 2006 +0100

    chelsio: spaces, tabs and friends
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 56c4a5a46f8e0264a96485d4f3b9a301f70e6d7e
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Mon Dec 11 23:41:36 2006 +0100

    chelsio: the return statement is not a function
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit dd1eb1308ca52e6ddb121cba66ffd6e426ac4ce8
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 5 22:38:00 2006 +0100

    chelsio: move return, break and continue statements on their own line
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit d697fe74ac0455e41fc323887390ec0f8fb4406d
Author: Zhu Yi <yi.zhu@intel.com>
Date:   Thu Jan 11 17:32:54 2007 +0800

    [PATCH] ipw2200: add iwconfig rts/frag auto support
    
    This patch add ipw2200 support for iwconfig rts/frag auto.
    
    Signed-off-by: Zhu Yi <yi.zhu@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit da69fa9164356c641fb5b3dd234448eebe60be04
Author: Daniel Drake <dsd@gentoo.org>
Date:   Thu Jan 4 03:33:54 2007 +0000

    [PATCH] zd1211rw: Add ID for ZyXEL ZyAIR G-220 v2
    
    Tested by Marijn Schouten
    zd1211b chip 0586:340f v4810 high 00-13-49 AL2230_RF pa0 g---
    FCC ID: I88G220V2
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit c17b45e4cd79939d0dbe154cb578f85ce09f5c04
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue Jan 2 21:22:05 2007 -0500

    [PATCH] softmac: avoid assert in ieee80211softmac_wx_get_rate
    
    Unconfigured bcm43xx device can hit an assert() during wx_get_rate
    queries.  This is because bcm43xx calls ieee80211softmac_start late
    (i.e. during open instead of probe).
    
       bcm43xx_net_open ->
          bcm43xx_init_board ->
             bcm43xx_select_wireless_core ->
                ieee80211softmac_start
    
    Fix is to check that device is running before completing
    ieee80211softmac_wx_get_rate.
    
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 274b0b2c3e600123829604ab3b9b7d3e520792b4
Author: Kai Engert <kengert@redhat.com>
Date:   Tue Dec 12 21:09:41 2006 +0100

    [PATCH] prism54: add ethtool -i interface
    
    Add support for "ethtool -i" to prism54 driver.
    
    ethtool -i queries the specified device for
    associated driver information.
    
    This helps tools like Fedora's system-config-network to
    provide GUI management of network devices.
    I learned how to write this patch by reading the ipw2100
    driver code.
    
    Signed-off-by: Kai Engert <kengert@redhat.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 601e3cdfba73ce3efbbac42b41762ae2fcb0b8a8
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Sat Dec 30 23:30:32 2006 -0600

    [PATCH] bcm43xx: Interrogate hardware-enable switch and update LEDs
    
    The current bcm43xx driver ignores any wireless-enable switches on mini-PCI
    and mini-PCI-E cards. This patch implements a new routine to interrogate the
    radio hardware enabled bit in the interface, logs the initial state and any
    changes in the switch (if debugging enabled), activates the LED to show the
    state, and changes the periodic work handler to provide 1 second response
    to switch changes and to account for changes in the periodic work specs.
    
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit d58b6b011772ff5ea428157493b5c917c39b481f
Author: Daniel Drake <dsd@gentoo.org>
Date:   Sat Dec 30 22:38:23 2006 +0000

    [PATCH] zd1211rw: Add ID for Linksys WUSBF54G
    
    Tested by Henrik Hjelte
    zd1211b chip 13b1:0024 v4802 high 00-14-bf AL2230_RF pa0 ----
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit ccd04e8492144a72c6b80e7588a1e5620c39d0b2
Author: Michael Buesch <mb@bu3sch.de>
Date:   Fri Dec 15 21:32:44 2006 +0100

    [PATCH] Update Prism54 MAINTAINERS entry
    
    prism54-private@prism54.org bounces with
    
        SMTP error from remote mailer after RCPT TO:<prism54-private@prism54.org>:
        host mx1.tuxfamily.net [212.85.158.8]: 550 unknown user
    
    developers@islsm.org seems to be the new mailing list.
    
    Signed-off-by: Michael Buesch <mb@bu3sch.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 4c14b51c7716aa5bf11647308f5679e25a768e75
Author: Daniel Drake <dsd@gentoo.org>
Date:   Tue Dec 12 01:26:11 2006 +0000

    [PATCH] zd1211rw: Remove addressing abstraction
    
    Instead of passing our own custom 32-bit addresses around and
    translating them, this patch makes all our register address constants
    absolute and removes the translation.
    
    There are two ugly parts:
     - fw_reg_addr() is needed to compute addresses of firmware registers, as this
       is dynamic based upon firmware
     - inc_addr() needs a small hack to handle byte vs word addressing
    
    However, both of those are only small, and we don't use fw_regs a whole
    lot anyway.
    
    The bonuses here include simplicity and improved driver readability. Also, the
    fact that registers are now referenced by 16-bit absolute addresses (as
    opposed to 32-bit pseudo addresses) means that over 2kb compiled code size has
    been shaved off.
    
    Includes some touchups and sparse fixes from Ulrich Kunitz.
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 4c85640796f96ce1f2a7243a88125b5c86d1337b
Author: Daniel Drake <dsd@gentoo.org>
Date:   Tue Dec 12 01:25:52 2006 +0000

    [PATCH] zd1211rw: Consistency for address space constants
    
    The zd1211rw address space has confused me once too many times. This
    patch introduces the following naming notation:
    
    Memory space is split into segments (cr, fw, eeprom) and segments may
    contain components (e.g. boot code inside eeprom). These names are
    arbitrary and only for the description below:
    
    x_START: Absolute address of segment start
    (previously these were named such as CR_BASE_OFFSET, but they weren't
    really offsets unless you were considering them as an offset to 0)
    
    x_LEN: Segment length
    
    x_y_LEN: Length of component y of segment x
    
    x_y_OFFSET: Relative address of component y into segment x. The absolute
    address for this component is (x_START + x_y_OFFSET)
    
    I also renamed EEPROM registers to EEPROM data. These 'registers' can't
    be written to using standard I/O and really represent predefined data
    from the vendor.
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 9ff88f6ba8212be972276a314e9153913e2068e5
Author: Daniel Drake <dsd@gentoo.org>
Date:   Tue Dec 12 01:25:37 2006 +0000

    [PATCH] zd1211rw: 2 new ZD1211B device ID's
    
    Philips SNU5600, tested by unibrow
    zd1211b chip 0471:1236 v4810 high 00-12-bf AL2230_RF pa0 g--
    
    SMC Ez Connect 802.11g (SMCWUSB-G), tested by Victorino Sanz Prat
    zd1211b chip 083a:4505 v4810 full 00-13-f7 AL2230_RF pa0 g--N
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 4683efa0c4987f8c874064cc84c2c8529b5cc352
Author: Daniel Drake <dsd@gentoo.org>
Date:   Tue Dec 12 01:25:13 2006 +0000

    [PATCH] zd1211rw: Generic HMAC initialization
    
    Many of the registers written during ZD1211 HMAC initialization are
    duplicated exactly for ZD1211B. Move the identical ones into a generic
    part, and write the hardware-specific ones separately.
    
    Signed-off-by: Daniel Drake <dsd@gentoo.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 244b55a141d47f4e05c20795c9d49cbf0d59e5ba
Author: Auke Kok <auke\\-jan.h.kok@intel.com>
Date:   Thu Jan 18 09:25:33 2007 -0800

    e1000: update version to 7.3.20-k2
    
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

commit 2ba8af5ab03f4a63df3665eb638ede645a599607
Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Thu Jan 18 09:25:31 2007 -0800

    e1000: tune our dynamic itr transmit packet accounting
    
    The driver was still mis-calculating the number of bytes sent during
    transmit, now the driver computes what appears to be exactly 100%
    correct byte counts (not including CRC) when figuring out how many
    bytes and frames were sent during the current transmit packet.

commit 77c54723f08b62170b5f18c13e00ae445892296f
Author: Bruce Allan <bruce.w.allan@intel.com>
Date:   Thu Jan 18 09:25:28 2007 -0800

    e1000: clear ip csum info from context descriptor
    
    Since the driver sets the IP checksum insertion bit (IXSM in Status
    field) in transmit context descriptors, it should clear the IP checksum
    bits of any garbage so as not to confuse the hardware.
    
    Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

commit f9e6f156c17bae743d6a1b6114edb0efca32c4ba
Author: Auke Kok <auke\\-jan.h.kok@intel.com>
Date:   Thu Jan 18 09:25:26 2007 -0800

    e1000: display flow control of link status at link up
    
    Print RX/TX flow control setting at link up time to display the
    actual link FC properties instead of the advertised values.
    
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

commit 151d11fb5bdce5e27d59cf5616a95490d0c084e0
Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Thu Jan 18 09:25:23 2007 -0800

    e1000: fix NAPI performance on 4-port adapters
    
    This fix attempts to solve a customer (IBM) reported issue with NAPI
    enabled e1000 having bad performance when transmitting simultaneously
    on four ports.  The issue comes down to an interaction between NAPI,
    hardware interrupt balancing, and the driver rescheduling poll on
    the same processor.  Try to fix by allowing the driver to re-enable
    interrupts sooner instead of polling one more time, when there was
    recently all the work completed in cleanup.
    
    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

commit f39668f782de716823978534ea0ad1791dd17f66
Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Thu Jan 18 09:25:21 2007 -0800

    e1000: Fix MSI only interrupt handler routine
    
    Unfortunately the read-free MSI interrupt handler needs to flush write
    the icr register and thus we can't be read-free. Our MSI irq routine
    thus becomes a lot more simpler since we don't need to track link state
    anymore.
    
    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

commit 9455a51b63f31f7747b64bdefe64d13385cf8fb0
Author: Auke Kok <auke\\-jan.h.kok@intel.com>
Date:   Thu Jan 18 09:25:18 2007 -0800

    e1000: clean up debug output defines
    
    Remove unused MSGOUT macro and add "\n" to function debug output.
    
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

commit 951c9a69efe280807e6a8dbb1c46759e357be382
Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date:   Thu Jan 18 09:25:15 2007 -0800

    e1000: simplify case handling gigabit at half duplex
    
    Remvoe duplicate code handling erraneous user supplied wrong case
    of gigabit speed with half duplex.
    
    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
 MAINTAINERS                             |    6 
 drivers/net/Kconfig                     |   21 
 drivers/net/bnx2.c                      |   29 
 drivers/net/bonding/bonding.h           |    9 
 drivers/net/chelsio/common.h            |    6 
 drivers/net/chelsio/ixf1010.c           |  Unmerged
 drivers/net/chelsio/sge.c               |   33 +
 drivers/net/chelsio/vsc8244.c           |  Unmerged
 drivers/net/cxgb3/adapter.h             |  Unmerged
 drivers/net/cxgb3/ael1002.c             |  Unmerged
 drivers/net/cxgb3/common.h              |  Unmerged
 drivers/net/cxgb3/cxgb3_ctl_defs.h      |  Unmerged
 drivers/net/cxgb3/cxgb3_defs.h          |  Unmerged
 drivers/net/cxgb3/cxgb3_ioctl.h         |  Unmerged
 drivers/net/cxgb3/cxgb3_main.c          |  Unmerged
 drivers/net/cxgb3/cxgb3_offload.c       |  Unmerged
 drivers/net/cxgb3/cxgb3_offload.h       |  Unmerged
 drivers/net/cxgb3/firmware_exports.h    |  Unmerged
 drivers/net/cxgb3/l2t.c                 |  Unmerged
 drivers/net/cxgb3/l2t.h                 |  Unmerged
 drivers/net/cxgb3/mc5.c                 |  Unmerged
 drivers/net/cxgb3/regs.h                |  Unmerged
 drivers/net/cxgb3/sge.c                 |  Unmerged
 drivers/net/cxgb3/t3_cpl.h              |  Unmerged
 drivers/net/cxgb3/t3_hw.c               |  Unmerged
 drivers/net/cxgb3/t3cdev.h              |  Unmerged
 drivers/net/cxgb3/version.h             |  Unmerged
 drivers/net/cxgb3/vsc8211.c             |  Unmerged
 drivers/net/cxgb3/xgmac.c               |  Unmerged
 drivers/net/e1000/e1000_main.c          |   21 
 drivers/net/forcedeth.c                 |  282 +++++
 drivers/net/macmace.c                   |    8 
 drivers/net/macsonic.c                  |    4 
 drivers/net/myri10ge/myri10ge.c         |    7 
 drivers/net/qla3xxx.c                   | 1874 +++++++++++++++++++------------
 drivers/net/qla3xxx.h                   |   40 +
 drivers/net/s2io.c                      |    4 
 drivers/net/sc92031.c                   |  Unmerged
 drivers/net/skfp/drvfbi.c               |   27 
 drivers/net/sky2.c                      |   82 +
 drivers/net/spider_net.c                |  299 +++++
 drivers/net/spider_net.h                |   17 
 drivers/net/wan/hdlc.c                  |    4 
 drivers/net/wireless/zd1211rw/zd_chip.c |   24 
 drivers/net/wireless/zd1211rw/zd_chip.h |   35 +
 drivers/net/wireless/zd1211rw/zd_def.h  |    2 
 drivers/net/wireless/zd1211rw/zd_usb.c  |    7 
 drivers/net/wireless/zd1211rw/zd_usb.h  |    3 
 48 files changed, 2132 insertions(+), 712 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4dde7f..3f55891 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3007,9 +3007,15 @@ W:	ftp://ftp.kernel.org/pub/linux/kernel
 S:	Supported
 
 PRISM54 WIRELESS DRIVER
+<<<<<<< HEAD/MAINTAINERS
 P:	Luis R. Rodriguez
 M:	mcgrof@gmail.com
 L:	linux-wireless@vger.kernel.org
+=======
+P:	Prism54 Development Team
+M:	developers@islsm.org
+L:	netdev@vger.kernel.org
+>>>>>>> /MAINTAINERS
 W:	http://prism54.org
 S:	Maintained
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 520f6f4..0a45ad2 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2380,6 +2380,7 @@ config CHELSIO_T1_NAPI
 	  NAPI is a driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card.
 
+<<<<<<< HEAD/drivers/net/Kconfig
 config CHELSIO_T3
 	tristate "Chelsio Communications T3 10Gb Ethernet support"
 	depends on PCI
@@ -2399,6 +2400,26 @@ config CHELSIO_T3
 	  To compile this driver as a module, choose M here: the module
 	  will be called cxgb3.
 
+=======
+config CHELSIO_T3
+        tristate "Chelsio Communications T3 10Gb Ethernet support"
+        depends on PCI
+        help
+          This driver supports Chelsio T3-based gigabit and 10Gb Ethernet
+          adapters.
+
+          For general information about Chelsio and our products, visit
+          our website at <http://www.chelsio.com>.
+
+          For customer support, please visit our customer support page at
+          <http://www.chelsio.com/support.htm>.
+
+          Please send feedback to <linux-bugs@chelsio.com>.
+
+          To compile this driver as a module, choose M here: the module
+          will be called cxgb3.
+
+>>>>>>> /drivers/net/Kconfig
 config EHEA
 	tristate "eHEA Ethernet support"
 	depends on IBMEBUS
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 24e7f9a..fff2dda 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -42,6 +42,10 @@ #endif
 #include <net/ip.h>
 #include <net/tcp.h>
 #include <net/checksum.h>
+<<<<<<< HEAD/drivers/net/bnx2.c
+=======
+#define BCM_TSO 1
+>>>>>>> /drivers/net/bnx2.c
 #include <linux/workqueue.h>
 #include <linux/crc32.h>
 #include <linux/prefetch.h>
@@ -5181,7 +5185,12 @@ bnx2_start_xmit(struct sk_buff *skb, str
 		vlan_tag_flags |=
 			(TX_BD_FLAGS_VLAN_TAG | (vlan_tx_tag_get(skb) << 16));
 	}
+<<<<<<< HEAD/drivers/net/bnx2.c
 	if ((mss = skb_shinfo(skb)->gso_size)) {
+=======
+	if ((mss = skb_shinfo(skb)->gso_size) &&
+		(skb->len > (bp->dev->mtu + ETH_HLEN))) {
+>>>>>>> /drivers/net/bnx2.c
 		u32 tcp_opt_len, ip_tcp_len;
 		struct iphdr *iph;
 
@@ -5226,7 +5235,13 @@ bnx2_start_xmit(struct sk_buff *skb, str
 						   (tcp_opt_len >> 2)) << 8;
 			}
 		}
+<<<<<<< HEAD/drivers/net/bnx2.c
 	} else
+=======
+	}
+	else
+	{
+>>>>>>> /drivers/net/bnx2.c
 		mss = 0;
 
 	mapping = pci_map_single(bp->pdev, skb->data, len, PCI_DMA_TODEVICE);
@@ -6908,6 +6923,20 @@ #endif
 		printk("%2.2x", dev->dev_addr[i]);
 	printk("\n");
 
+<<<<<<< HEAD/drivers/net/bnx2.c
+=======
+	dev->features |= NETIF_F_SG;
+	if (bp->flags & USING_DAC_FLAG)
+		dev->features |= NETIF_F_HIGHDMA;
+	dev->features |= NETIF_F_IP_CSUM;
+#ifdef BCM_VLAN
+	dev->features |= NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
+#endif
+	dev->features |= NETIF_F_TSO | NETIF_F_TSO_ECN;
+
+	netif_carrier_off(bp->dev);
+
+>>>>>>> /drivers/net/bnx2.c
 	return 0;
 }
 
diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index 6dcbd25..727ef4e 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -22,8 +22,13 @@ #include <linux/kobject.h>
 #include "bond_3ad.h"
 #include "bond_alb.h"
 
+<<<<<<< HEAD/drivers/net/bonding/bonding.h
 #define DRV_VERSION	"3.1.3"
 #define DRV_RELDATE	"June 13, 2007"
+=======
+#define DRV_VERSION	"3.1.2"
+#define DRV_RELDATE	"January 20, 2007"
+>>>>>>> /drivers/net/bonding/bonding.h
 #define DRV_NAME	"bonding"
 #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
 
@@ -243,8 +248,12 @@ static inline int slave_do_arp_validate(
 	return bond->params.arp_validate & (1 << slave->state);
 }
 
+<<<<<<< HEAD/drivers/net/bonding/bonding.h
 static inline unsigned long slave_last_rx(struct bonding *bond,
 					struct slave *slave)
+=======
+static inline u32 slave_last_rx(struct bonding *bond, struct slave *slave)
+>>>>>>> /drivers/net/bonding/bonding.h
 {
 	if (slave_do_arp_validate(bond, slave))
 		return slave->last_arp_rx;
diff --git a/drivers/net/chelsio/common.h b/drivers/net/chelsio/common.h
index 8ba702c..040098d 100644
--- a/drivers/net/chelsio/common.h
+++ b/drivers/net/chelsio/common.h
@@ -322,9 +322,15 @@ struct board_info {
 	unsigned char           mdio_mdiinv;
 	unsigned char           mdio_mdc;
 	unsigned char           mdio_phybaseaddr;
+<<<<<<< HEAD/drivers/net/chelsio/common.h
 	const struct gmac      *gmac;
 	const struct gphy      *gphy;
 	const struct mdio_ops  *mdio_ops;
+=======
+	struct gmac            *gmac;
+	struct gphy            *gphy;
+	struct mdio_ops        *mdio_ops;
+>>>>>>> /drivers/net/chelsio/common.h
 	const char             *desc;
 };
 
* Unmerged path drivers/net/chelsio/ixf1010.c
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index e4f874a..27df21f 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1062,11 +1062,19 @@ static inline struct sk_buff *get_packet
 					    pci_unmap_addr(ce, dma_addr),
 					    pci_unmap_len(ce, dma_len),
 					    PCI_DMA_FROMDEVICE);
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 		skb_copy_from_linear_data(ce->skb, skb->data, len);
 		pci_dma_sync_single_for_device(pdev,
 					       pci_unmap_addr(ce, dma_addr),
 					       pci_unmap_len(ce, dma_len),
 					       PCI_DMA_FROMDEVICE);
+=======
+		memcpy(skb->data, ce->skb->data, len);
+		pci_dma_sync_single_for_device(pdev,
+					       pci_unmap_addr(ce, dma_addr),
+					       pci_unmap_len(ce, dma_len),
+					       PCI_DMA_FROMDEVICE);
+>>>>>>> /drivers/net/chelsio/sge.c
 		recycle_fl_buf(fl, fl->cidx);
 		return skb;
 	}
@@ -1695,13 +1703,16 @@ irqreturn_t t1_interrupt(int irq, void *
 {
 	int work_done;
 	struct adapter *adapter = cookie;
-	struct respQ *Q = &adapter->sge->respQ;
 
 	spin_lock(&adapter->async_lock);
 
 	writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
 
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 	if (likely(responses_pending(adapter)))
+=======
+	if (likely(responses_pending(adapter))
+>>>>>>> /drivers/net/chelsio/sge.c
 		work_done = process_responses(adapter, -1);
 	else
 		work_done = t1_slow_intr_handler(adapter);
@@ -2083,6 +2094,7 @@ static void espibug_workaround_t204(unsi
 			return;
 
 		for (i = 0; i < nports; i++) {
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 			struct sk_buff *skb = sge->espibug_skb[i];
 
 			if (!netif_running(adapter->port[i].dev) ||
@@ -2104,6 +2116,25 @@ static void espibug_workaround_t204(unsi
 							       ch_mac_addr,
 							       ETH_ALEN);
 				skb->cb[0] = 0xff;
+=======
+			struct sk_buff *skb = sge->espibug_skb[i];
+
+			if (!netif_running(adapter->port[i].dev) ||
+			    netif_queue_stopped(adapter->port[i].dev) ||
+			    !seop[i] || ((seop[i] & 0xfff) != 0) || !skb)
+				continue;
+
+			if (!skb->cb[0]) {
+				u8 ch_mac_addr[ETH_ALEN] = {
+					0x0, 0x7, 0x43, 0x0, 0x0, 0x0
+				};
+
+				memcpy(skb->data + sizeof(struct cpl_tx_pkt),
+					ch_mac_addr, ETH_ALEN);
+				memcpy(skb->data + skb->len - 10,
+					ch_mac_addr, ETH_ALEN);
+				skb->cb[0] = 0xff;
+>>>>>>> /drivers/net/chelsio/sge.c
 			}
 
 			/* bump the reference count to avoid freeing of
* Unmerged path drivers/net/chelsio/vsc8244.c
* Unmerged path drivers/net/cxgb3/adapter.h
* Unmerged path drivers/net/cxgb3/ael1002.c
* Unmerged path drivers/net/cxgb3/common.h
* Unmerged path drivers/net/cxgb3/cxgb3_ctl_defs.h
* Unmerged path drivers/net/cxgb3/cxgb3_defs.h
* Unmerged path drivers/net/cxgb3/cxgb3_ioctl.h
* Unmerged path drivers/net/cxgb3/cxgb3_main.c
* Unmerged path drivers/net/cxgb3/cxgb3_offload.c
* Unmerged path drivers/net/cxgb3/cxgb3_offload.h
* Unmerged path drivers/net/cxgb3/firmware_exports.h
* Unmerged path drivers/net/cxgb3/l2t.c
* Unmerged path drivers/net/cxgb3/l2t.h
* Unmerged path drivers/net/cxgb3/mc5.c
* Unmerged path drivers/net/cxgb3/regs.h
* Unmerged path drivers/net/cxgb3/sge.c
* Unmerged path drivers/net/cxgb3/t3_cpl.h
* Unmerged path drivers/net/cxgb3/t3_hw.c
* Unmerged path drivers/net/cxgb3/t3cdev.h
* Unmerged path drivers/net/cxgb3/version.h
* Unmerged path drivers/net/cxgb3/vsc8211.c
* Unmerged path drivers/net/cxgb3/xgmac.c
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 4a22595..409d336 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2908,7 +2908,11 @@ e1000_tso(struct e1000_adapter *adapter,
 								 IPPROTO_TCP,
 								 0);
 			cmd_length = E1000_TXD_CMD_IP;
+<<<<<<< HEAD/drivers/net/e1000/e1000_main.c
 			ipcse = skb_transport_offset(skb) - 1;
+=======
+			ipcse = skb->h.raw - skb->data - 1;
+>>>>>>> /drivers/net/e1000/e1000_main.c
 		} else if (skb->protocol == htons(ETH_P_IPV6)) {
 			ipv6_hdr(skb)->payload_len = 0;
 			tcp_hdr(skb)->check =
@@ -2969,8 +2973,12 @@ e1000_tx_csum(struct e1000_adapter *adap
 
 		context_desc->lower_setup.ip_config = 0;
 		context_desc->upper_setup.tcp_fields.tucss = css;
+<<<<<<< HEAD/drivers/net/e1000/e1000_main.c
 		context_desc->upper_setup.tcp_fields.tucso =
 			css + skb->csum_offset;
+=======
+		context_desc->upper_setup.tcp_fields.tucso = css + skb->csum;
+>>>>>>> /drivers/net/e1000/e1000_main.c
 		context_desc->upper_setup.tcp_fields.tucse = 0;
 		context_desc->tcp_seg_setup.data = 0;
 		context_desc->cmd_and_length = cpu_to_le32(E1000_TXD_CMD_DEXT);
@@ -3800,7 +3808,7 @@ #else
 
 	for (i = 0; i < E1000_MAX_INTR; i++)
 		if (unlikely(!adapter->clean_rx(adapter, adapter->rx_ring) &
-		   !e1000_clean_tx_irq(adapter, adapter->tx_ring)))
+		   e1000_clean_tx_irq(adapter, adapter->tx_ring)))
 			break;
 
 	if (likely(adapter->itr_setting & 3))
@@ -3902,7 +3910,7 @@ #else
 
 	for (i = 0; i < E1000_MAX_INTR; i++)
 		if (unlikely(!adapter->clean_rx(adapter, adapter->rx_ring) &
-		   !e1000_clean_tx_irq(adapter, adapter->tx_ring)))
+		   e1000_clean_tx_irq(adapter, adapter->tx_ring)))
 			break;
 
 	if (likely(adapter->itr_setting & 3))
@@ -3952,7 +3960,7 @@ e1000_clean(struct net_device *poll_dev,
 	poll_dev->quota -= work_done;
 
 	/* If no Tx and not enough Rx work done, exit the polling mode */
-	if ((!tx_cleaned && (work_done == 0)) ||
+	if ((tx_cleaned && (work_done < work_to_do)) ||
 	   !netif_running(poll_dev)) {
 quit_polling:
 		if (likely(adapter->itr_setting & 3))
@@ -3982,7 +3990,7 @@ e1000_clean_tx_irq(struct e1000_adapter 
 #ifdef CONFIG_E1000_NAPI
 	unsigned int count = 0;
 #endif
-	boolean_t cleaned = FALSE;
+	boolean_t cleaned = TRUE;
 	unsigned int total_tx_bytes=0, total_tx_packets=0;
 
 	i = tx_ring->next_to_clean;
@@ -4016,7 +4024,10 @@ #endif
 #ifdef CONFIG_E1000_NAPI
 #define E1000_TX_WEIGHT 64
 		/* weight of a sort for tx, to avoid endless transmit cleanup */
-		if (count++ == E1000_TX_WEIGHT) break;
+		if (count++ == E1000_TX_WEIGHT) {
+			cleaned = FALSE;
+			break;
+		}
 #endif
 	}
 
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 69f5f36..192854d 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -174,11 +174,18 @@ #define DEV_HAS_MSI             0x0040  
 #define DEV_HAS_MSI_X           0x0080  /* device supports MSI-X */
 #define DEV_HAS_POWER_CNTRL     0x0100  /* device supports power savings */
 #define DEV_HAS_PAUSEFRAME_TX   0x0200  /* device supports tx pause frames */
+<<<<<<< HEAD/drivers/net/forcedeth.c
 #define DEV_HAS_STATISTICS_V1   0x0400  /* device supports hw statistics version 1 */
 #define DEV_HAS_STATISTICS_V2   0x0800  /* device supports hw statistics version 2 */
 #define DEV_HAS_TEST_EXTENDED   0x1000  /* device supports extended diagnostic test */
 #define DEV_HAS_MGMT_UNIT       0x2000  /* device supports management unit */
 #define DEV_HAS_CORRECT_MACADDR 0x4000  /* device supports correct mac address order */
+=======
+#define DEV_HAS_STATISTICS_V1   0x0400  /* device supports hw statistics version 1 */
+#define DEV_HAS_STATISTICS_V2   0x0800  /* device supports hw statistics version 2 */
+#define DEV_HAS_TEST_EXTENDED   0x1000  /* device supports extended diagnostic test */
+#define DEV_HAS_MGMT_UNIT       0x2000  /* device supports management unit */
+>>>>>>> /drivers/net/forcedeth.c
 
 enum {
 	NvRegIrqStatus = 0x000,
@@ -1521,6 +1528,7 @@ static int nv_alloc_rx(struct net_device
 	struct fe_priv *np = netdev_priv(dev);
 	struct ring_desc* less_rx;
 
+<<<<<<< HEAD/drivers/net/forcedeth.c
 	less_rx = np->get_rx.orig;
 	if (less_rx-- == np->first_rx.orig)
 		less_rx = np->last_rx.orig;
@@ -1547,12 +1555,51 @@ static int nv_alloc_rx(struct net_device
 	}
 	return 0;
 }
+=======
+	less_rx = np->get_rx.orig;
+	if (less_rx-- == np->first_rx.orig)
+		less_rx = np->last_rx.orig;
+
+	while (np->put_rx.orig != less_rx) {
+		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		if (skb) {
+			skb->dev = dev;
+			np->put_rx_ctx->skb = skb;
+			np->put_rx_ctx->dma = pci_map_single(np->pci_dev, skb->data,
+							     skb->end-skb->data, PCI_DMA_FROMDEVICE);
+			np->put_rx_ctx->dma_len = skb->end-skb->data;
+			np->put_rx.orig->buf = cpu_to_le32(np->put_rx_ctx->dma);
+			wmb();
+			np->put_rx.orig->flaglen = cpu_to_le32(np->rx_buf_sz | NV_RX_AVAIL);
+			if (unlikely(np->put_rx.orig++ == np->last_rx.orig))
+				np->put_rx.orig = np->first_rx.orig;
+			if (unlikely(np->put_rx_ctx++ == np->last_rx_ctx))
+				np->put_rx_ctx = np->first_rx_ctx;
+		} else {
+			return 1;
+		}
+	}
+	return 0;
+}
+>>>>>>> /drivers/net/forcedeth.c
 
+<<<<<<< HEAD/drivers/net/forcedeth.c
 static int nv_alloc_rx_optimized(struct net_device *dev)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	struct ring_desc_ex* less_rx;
+=======
+static int nv_alloc_rx_optimized(struct net_device *dev)
+{
+	struct fe_priv *np = netdev_priv(dev);
+	struct ring_desc_ex* less_rx;
+
+	less_rx = np->get_rx.ex;
+	if (less_rx-- == np->first_rx.ex)
+		less_rx = np->last_rx.ex;
+>>>>>>> /drivers/net/forcedeth.c
 
+<<<<<<< HEAD/drivers/net/forcedeth.c
 	less_rx = np->get_rx.ex;
 	if (less_rx-- == np->first_rx.ex)
 		less_rx = np->last_rx.ex;
@@ -1568,6 +1615,18 @@ static int nv_alloc_rx_optimized(struct 
 			np->put_rx_ctx->dma_len = skb_tailroom(skb);
 			np->put_rx.ex->bufhigh = cpu_to_le64(np->put_rx_ctx->dma) >> 32;
 			np->put_rx.ex->buflow = cpu_to_le64(np->put_rx_ctx->dma) & 0x0FFFFFFFF;
+=======
+	while (np->put_rx.ex != less_rx) {
+		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
+		if (skb) {
+			skb->dev = dev;
+			np->put_rx_ctx->skb = skb;
+			np->put_rx_ctx->dma = pci_map_single(np->pci_dev, skb->data,
+							     skb->end-skb->data, PCI_DMA_FROMDEVICE);
+			np->put_rx_ctx->dma_len = skb->end-skb->data;
+			np->put_rx.ex->bufhigh = cpu_to_le64(np->put_rx_ctx->dma) >> 32;
+			np->put_rx.ex->buflow = cpu_to_le64(np->put_rx_ctx->dma) & 0x0FFFFFFFF;
+>>>>>>> /drivers/net/forcedeth.c
 			wmb();
 			np->put_rx.ex->flaglen = cpu_to_le32(np->rx_buf_sz | NV_RX2_AVAIL);
 			if (unlikely(np->put_rx.ex++ == np->last_rx.ex))
@@ -1747,6 +1806,7 @@ static void nv_drain_rx(struct net_devic
 			np->rx_ring.ex[i].buflow = 0;
 		}
 		wmb();
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		if (np->rx_skb[i].skb) {
 			pci_unmap_single(np->pci_dev, np->rx_skb[i].dma,
 					 (skb_end_pointer(np->rx_skb[i].skb) -
@@ -1754,6 +1814,14 @@ static void nv_drain_rx(struct net_devic
 					 PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(np->rx_skb[i].skb);
 			np->rx_skb[i].skb = NULL;
+=======
+		if (np->rx_skb[i].skb) {
+			pci_unmap_single(np->pci_dev, np->rx_skb[i].dma,
+						np->rx_skb[i].skb->end-np->rx_skb[i].skb->data,
+						PCI_DMA_FROMDEVICE);
+			dev_kfree_skb(np->rx_skb[i].skb);
+			np->rx_skb[i].skb = NULL;
+>>>>>>> /drivers/net/forcedeth.c
 		}
 	}
 }
@@ -2372,6 +2440,153 @@ static int nv_rx_process(struct net_devi
 				goto next_pkt;
 			}
 		}
+<<<<<<< HEAD/drivers/net/forcedeth.c
+	} else {
+		/* short packet. Accept only if 802 values are also short */
+		if (protolen > ETH_ZLEN) {
+			dprintk(KERN_DEBUG "%s: nv_getlen: discarding short packet.\n",
+					dev->name);
+			return -1;
+		}
+		dprintk(KERN_DEBUG "%s: nv_getlen: accepting %d bytes.\n",
+				dev->name, datalen);
+		return datalen;
+	}
+}
+
+static int nv_rx_process(struct net_device *dev, int limit)
+{
+	struct fe_priv *np = netdev_priv(dev);
+	u32 flags;
+	u32 rx_processed_cnt = 0;
+	struct sk_buff *skb;
+	int len;
+
+	while((np->get_rx.orig != np->put_rx.orig) &&
+	      !((flags = le32_to_cpu(np->get_rx.orig->flaglen)) & NV_RX_AVAIL) &&
+		(rx_processed_cnt++ < limit)) {
+
+		dprintk(KERN_DEBUG "%s: nv_rx_process: flags 0x%x.\n",
+					dev->name, flags);
+
+		/*
+		 * the packet is for us - immediately tear down the pci mapping.
+		 * TODO: check if a prefetch of the first cacheline improves
+		 * the performance.
+		 */
+		pci_unmap_single(np->pci_dev, np->get_rx_ctx->dma,
+				np->get_rx_ctx->dma_len,
+				PCI_DMA_FROMDEVICE);
+		skb = np->get_rx_ctx->skb;
+		np->get_rx_ctx->skb = NULL;
+
+		{
+			int j;
+			dprintk(KERN_DEBUG "Dumping packet (flags 0x%x).",flags);
+			for (j=0; j<64; j++) {
+				if ((j%16) == 0)
+					dprintk("\n%03x:", j);
+				dprintk(" %02x", ((unsigned char*)skb->data)[j]);
+			}
+			dprintk("\n");
+		}
+		/* look at what we actually got: */
+		if (np->desc_ver == DESC_VER_1) {
+			if (likely(flags & NV_RX_DESCRIPTORVALID)) {
+				len = flags & LEN_MASK_V1;
+				if (unlikely(flags & NV_RX_ERROR)) {
+					if (flags & NV_RX_ERROR4) {
+						len = nv_getlen(dev, skb->data, len);
+						if (len < 0) {
+							np->stats.rx_errors++;
+							dev_kfree_skb(skb);
+							goto next_pkt;
+						}
+					}
+					/* framing errors are soft errors */
+					else if (flags & NV_RX_FRAMINGERR) {
+						if (flags & NV_RX_SUBSTRACT1) {
+							len--;
+						}
+					}
+					/* the rest are hard errors */
+					else {
+						if (flags & NV_RX_MISSEDFRAME)
+							np->stats.rx_missed_errors++;
+						if (flags & NV_RX_CRCERR)
+							np->stats.rx_crc_errors++;
+						if (flags & NV_RX_OVERFLOW)
+							np->stats.rx_over_errors++;
+						np->stats.rx_errors++;
+						dev_kfree_skb(skb);
+						goto next_pkt;
+					}
+				}
+			} else {
+				dev_kfree_skb(skb);
+				goto next_pkt;
+			}
+		} else {
+			if (likely(flags & NV_RX2_DESCRIPTORVALID)) {
+				len = flags & LEN_MASK_V2;
+				if (unlikely(flags & NV_RX2_ERROR)) {
+					if (flags & NV_RX2_ERROR4) {
+						len = nv_getlen(dev, skb->data, len);
+						if (len < 0) {
+							np->stats.rx_errors++;
+							dev_kfree_skb(skb);
+							goto next_pkt;
+						}
+					}
+					/* framing errors are soft errors */
+					else if (flags & NV_RX2_FRAMINGERR) {
+						if (flags & NV_RX2_SUBSTRACT1) {
+							len--;
+						}
+					}
+					/* the rest are hard errors */
+					else {
+						if (flags & NV_RX2_CRCERR)
+							np->stats.rx_crc_errors++;
+						if (flags & NV_RX2_OVERFLOW)
+							np->stats.rx_over_errors++;
+						np->stats.rx_errors++;
+						dev_kfree_skb(skb);
+						goto next_pkt;
+					}
+				}
+				if ((flags & NV_RX2_CHECKSUMMASK) == NV_RX2_CHECKSUMOK2)/*ip and tcp */ {
+					skb->ip_summed = CHECKSUM_UNNECESSARY;
+				} else {
+					if ((flags & NV_RX2_CHECKSUMMASK) == NV_RX2_CHECKSUMOK1 ||
+					    (flags & NV_RX2_CHECKSUMMASK) == NV_RX2_CHECKSUMOK3) {
+						skb->ip_summed = CHECKSUM_UNNECESSARY;
+					}
+				}
+			} else {
+				dev_kfree_skb(skb);
+				goto next_pkt;
+			}
+		}
+		/* got a valid packet - forward it to the network core */
+		skb_put(skb, len);
+		skb->protocol = eth_type_trans(skb, dev);
+		dprintk(KERN_DEBUG "%s: nv_rx_process: %d bytes, proto %d accepted.\n",
+					dev->name, len, skb->protocol);
+#ifdef CONFIG_FORCEDETH_NAPI
+		netif_receive_skb(skb);
+#else
+		netif_rx(skb);
+#endif
+		dev->last_rx = jiffies;
+		np->stats.rx_packets++;
+		np->stats.rx_bytes += len;
+next_pkt:
+		if (unlikely(np->get_rx.orig++ == np->last_rx.orig))
+			np->get_rx.orig = np->first_rx.orig;
+		if (unlikely(np->get_rx_ctx++ == np->last_rx_ctx))
+			np->get_rx_ctx = np->first_rx_ctx;
+=======
 		/* got a valid packet - forward it to the network core */
 		skb_put(skb, len);
 		skb->protocol = eth_type_trans(skb, dev);
@@ -2390,6 +2605,7 @@ next_pkt:
 			np->get_rx.orig = np->first_rx.orig;
 		if (unlikely(np->get_rx_ctx++ == np->last_rx_ctx))
 			np->get_rx_ctx = np->first_rx_ctx;
+>>>>>>> /drivers/net/forcedeth.c
 	}
 
 	return rx_processed_cnt;
@@ -3253,6 +3469,7 @@ static int nv_napi_poll(struct net_devic
 	unsigned long flags;
 	int retcode;
 
+<<<<<<< HEAD/drivers/net/forcedeth.c
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
 		pkts = nv_rx_process(dev, limit);
 		retcode = nv_alloc_rx(dev);
@@ -3260,6 +3477,12 @@ static int nv_napi_poll(struct net_devic
 		pkts = nv_rx_process_optimized(dev, limit);
 		retcode = nv_alloc_rx_optimized(dev);
 	}
+=======
+	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2)
+		pkts = nv_rx_process(dev, limit);
+	else
+		pkts = nv_rx_process_optimized(dev, limit);
+>>>>>>> /drivers/net/forcedeth.c
 
 	if (retcode) {
 		spin_lock_irqsave(&np->lock, flags);
@@ -5137,10 +5360,21 @@ static int __devinit nv_probe(struct pci
 			goto out_unmap;
 		np->tx_ring.ex = &np->rx_ring.ex[np->rx_ring_size];
 	}
+<<<<<<< HEAD/drivers/net/forcedeth.c
 	np->rx_skb = kcalloc(np->rx_ring_size, sizeof(struct nv_skb_map), GFP_KERNEL);
 	np->tx_skb = kcalloc(np->tx_ring_size, sizeof(struct nv_skb_map), GFP_KERNEL);
 	if (!np->rx_skb || !np->tx_skb)
+=======
+	np->rx_skb = kmalloc(sizeof(struct nv_skb_map) * np->rx_ring_size, GFP_KERNEL);
+	np->tx_skb = kmalloc(sizeof(struct nv_skb_map) * np->tx_ring_size, GFP_KERNEL);
+	if (!np->rx_skb || !np->tx_skb)
+>>>>>>> /drivers/net/forcedeth.c
 		goto out_freering;
+<<<<<<< HEAD/drivers/net/forcedeth.c
+=======
+	memset(np->rx_skb, 0, sizeof(struct nv_skb_map) * np->rx_ring_size);
+	memset(np->tx_skb, 0, sizeof(struct nv_skb_map) * np->tx_ring_size);
+>>>>>>> /drivers/net/forcedeth.c
 
 	dev->open = nv_open;
 	dev->stop = nv_close;
@@ -5501,50 +5735,95 @@ static struct pci_device_id pci_tbl[] = 
 	},
 	{	/* MCP61 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_16),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP61 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_17),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP61 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_18),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP61 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_19),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP65 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_20),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP65 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_21),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP65 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_22),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP65 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_23),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP67 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_24),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP67 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_25),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP67 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_26),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{	/* MCP67 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_27),
+<<<<<<< HEAD/drivers/net/forcedeth.c
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
 	},
 	{	/* MCP73 Ethernet Controller */
@@ -5562,6 +5841,9 @@ static struct pci_device_id pci_tbl[] = 
 	{	/* MCP73 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_31),
 		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR,
+=======
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_HIGH_DMA|DEV_HAS_POWER_CNTRL|DEV_HAS_MSI|DEV_HAS_PAUSEFRAME_TX|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT,
+>>>>>>> /drivers/net/forcedeth.c
 	},
 	{0,},
 };
diff --git a/drivers/net/macmace.c b/drivers/net/macmace.c
index 9a343b9..cf6af35 100644
--- a/drivers/net/macmace.c
+++ b/drivers/net/macmace.c
@@ -27,9 +27,13 @@ #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/crc32.h>
+<<<<<<< HEAD/drivers/net/macmace.c
 #include <linux/bitrev.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
+=======
+#include <linux/bitrev.h>
+>>>>>>> /drivers/net/macmace.c
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/macintosh.h>
@@ -99,8 +103,12 @@ static void mace_reset(struct net_device
 static irqreturn_t mace_interrupt(int irq, void *dev_id);
 static irqreturn_t mace_dma_intr(int irq, void *dev_id);
 static void mace_tx_timeout(struct net_device *dev);
+<<<<<<< HEAD/drivers/net/macmace.c
 static void __mace_set_address(struct net_device *dev, void *addr);
 
+=======
+
+>>>>>>> /drivers/net/macmace.c
 /*
  * Load a receive DMA channel with a base address and ring length
  */
diff --git a/drivers/net/macsonic.c b/drivers/net/macsonic.c
index e9ecdbf..fd0f9d4 100644
--- a/drivers/net/macsonic.c
+++ b/drivers/net/macsonic.c
@@ -127,6 +127,7 @@ static inline void bit_reverse_addr(unsi
 	int i;
 
 	for(i = 0; i < 6; i++)
+<<<<<<< HEAD/drivers/net/macsonic.c
 		addr[i] = bitrev8(addr[i]);
 }
 
@@ -168,6 +169,9 @@ static int macsonic_close(struct net_dev
 	if (dev->irq == IRQ_AUTO_3)
 		free_irq(IRQ_NUBUS_9, dev);
 	return err;
+=======
+		addr[i] = bitrev8(addr[i]);
+>>>>>>> /drivers/net/macsonic.c
 }
 
 int __init macsonic_init(struct net_device* dev)
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 43cdf73..7607beb 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -1475,7 +1475,10 @@ static const struct ethtool_ops myri10ge
 	.set_sg = ethtool_op_set_sg,
 	.get_tso = ethtool_op_get_tso,
 	.set_tso = ethtool_op_set_tso,
+<<<<<<< HEAD/drivers/net/myri10ge/myri10ge.c
 	.get_link = ethtool_op_get_link,
+=======
+>>>>>>> /drivers/net/myri10ge/myri10ge.c
 	.get_strings = myri10ge_get_strings,
 	.get_stats_count = myri10ge_get_stats_count,
 	.get_ethtool_stats = myri10ge_get_ethtool_stats,
@@ -2039,7 +2042,11 @@ again:
 	mss = 0;
 	max_segments = MXGEFW_MAX_SEND_DESC;
 
+<<<<<<< HEAD/drivers/net/myri10ge/myri10ge.c
 	if (skb_is_gso(skb)) {
+=======
+	if (skb->len > (dev->mtu + ETH_HLEN)) {
+>>>>>>> /drivers/net/myri10ge/myri10ge.c
 		mss = skb_shinfo(skb)->gso_size;
 		max_segments = MYRI10GE_MAX_SEND_DESC_TSO;
 	}
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index b1aed18..b655f67 100755
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -9,24 +9,22 @@ #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/list.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/dmapool.h>
-#include <linux/mempool.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/ip.h>
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
+=======
+#include <linux/in.h>
+>>>>>>> /drivers/net/qla3xxx.c
 #include <linux/netdevice.h>
-#include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
@@ -36,9 +34,15 @@ #include <linux/mm.h>
 
 #include "qla3xxx.h"
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 #define DRV_NAME  	"qla3xxx"
 #define DRV_STRING 	"QLogic ISP3XXX Network Driver"
 #define DRV_VERSION	"v2.03.00-k4"
+=======
+#define DRV_NAME	"qla3xxx"
+#define DRV_STRING	"QLogic ISP3XXX Network Driver"
+#define DRV_VERSION	"v2.02.00-k36"
+>>>>>>> /drivers/net/qla3xxx.c
 #define PFX		DRV_NAME " "
 
 static const char ql3xxx_driver_name[] = DRV_NAME;
@@ -49,9 +53,8 @@ MODULE_DESCRIPTION("QLogic ISP3XXX Netwo
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
-static const u32 default_msg
-    = NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK
-    | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN;
+static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
+	NETIF_MSG_LINK | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN;
 
 static int debug = -1;		/* defaults above */
 module_param(debug, int, 0);
@@ -62,10 +65,15 @@ module_param(msi, int, 0);
 MODULE_PARM_DESC(msi, "Turn on Message Signaled Interrupts.");
 
 static struct pci_device_id ql3xxx_pci_tbl[] __devinitdata = {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	{PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, QL3022_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, QL3032_DEVICE_ID)},
+=======
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, QL3022_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, QL3032_DEVICE_ID) },
+>>>>>>> /drivers/net/qla3xxx.c
 	/* required last entry */
-	{0,}
+	{ 0, }
 };
 
 MODULE_DEVICE_TABLE(pci, ql3xxx_pci_tbl);
@@ -97,39 +105,36 @@ static const PHY_DEVICE_INFO_t PHY_DEVIC
 /*
  * Caller must take hw_lock.
  */
-static int ql_sem_spinlock(struct ql3_adapter *qdev,
-			    u32 sem_mask, u32 sem_bits)
+static int ql_sem_spinlock(struct ql3_adapter *qdev, u32 sem_mask, u32 sem_bits)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
-	u32 value;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.semaphoreReg;
 	unsigned int seconds = 3;
+	u32 value;
 
 	do {
-		writel((sem_mask | sem_bits),
-		       &port_regs->CommonRegs.semaphoreReg);
-		value = readl(&port_regs->CommonRegs.semaphoreReg);
+		writel(sem_mask | sem_bits, reg);
+		value = readl(reg);
 		if ((value & (sem_mask >> 16)) == sem_bits)
 			return 0;
 		ssleep(1);
-	} while(--seconds);
-	return -1;
+	} while (--seconds);
+	return -EBUSY;
 }
 
 static void ql_sem_unlock(struct ql3_adapter *qdev, u32 sem_mask)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
-	writel(sem_mask, &port_regs->CommonRegs.semaphoreReg);
-	readl(&port_regs->CommonRegs.semaphoreReg);
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.semaphoreReg;
+
+	writel(sem_mask, reg);
+	readl(reg);
 }
 
 static int ql_sem_lock(struct ql3_adapter *qdev, u32 sem_mask, u32 sem_bits)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
-	u32 value;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.semaphoreReg;
 
-	writel((sem_mask | sem_bits), &port_regs->CommonRegs.semaphoreReg);
-	value = readl(&port_regs->CommonRegs.semaphoreReg);
-	return ((value & (sem_mask >> 16)) == sem_bits);
+	writel(sem_mask | sem_bits, reg);
+	return (readl(reg) & (sem_mask >> 16)) == sem_bits;
 }
 
 /*
@@ -137,92 +142,79 @@ static int ql_sem_lock(struct ql3_adapte
  */
 static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
 {
-	int i = 0;
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 1;
+	unsigned int i;
 
-	while (1) {
-		if (!ql_sem_lock(qdev,
-				 QL_DRVR_SEM_MASK,
-				 (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index)
-				  * 2) << 1)) {
-			if (i < 10) {
-				ssleep(1);
-				i++;
-			} else {
-				printk(KERN_ERR PFX "%s: Timed out waiting for "
-				       "driver lock...\n",
-				       qdev->ndev->name);
-				return 0;
-			}
-		} else {
-			printk(KERN_DEBUG PFX
-			       "%s: driver lock acquired.\n",
+	for (i = 0; i < 10; i++) {
+		if (ql_sem_lock(qdev, QL_DRVR_SEM_MASK, bits)) {
+			printk(KERN_DEBUG PFX "%s: driver lock acquired.\n",
 			       qdev->ndev->name);
 			return 1;
 		}
+		ssleep(1);
 	}
+	printk(KERN_ERR PFX "%s: Timed out waiting for driver lock...\n",
+	       qdev->ndev->name);
+	return 0;
 }
 
 static void ql_set_register_page(struct ql3_adapter *qdev, u32 page)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.ispControlStatus;
 
-	writel(((ISP_CONTROL_NP_MASK << 16) | page),
-			&port_regs->CommonRegs.ispControlStatus);
-	readl(&port_regs->CommonRegs.ispControlStatus);
+	writel((ISP_CONTROL_NP_MASK << 16) | page, reg);
+	readl(reg);
 	qdev->current_page = page;
 }
 
-static u32 ql_read_common_reg_l(struct ql3_adapter *qdev,
-			      u32 __iomem * reg)
+static u32 ql_read_common_reg_l(struct ql3_adapter *qdev, u32 __iomem * reg)
 {
+	unsigned long flags;
 	u32 value;
-	unsigned long hw_flags;
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	spin_lock_irqsave(&qdev->hw_lock, flags);
 	value = readl(reg);
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 
 	return value;
 }
 
-static u32 ql_read_common_reg(struct ql3_adapter *qdev,
-			      u32 __iomem * reg)
+static u32 ql_read_common_reg(struct ql3_adapter *qdev, u32 __iomem * reg)
 {
 	return readl(reg);
 }
 
 static u32 ql_read_page0_reg_l(struct ql3_adapter *qdev, u32 __iomem *reg)
 {
+	unsigned long flags;
 	u32 value;
-	unsigned long hw_flags;
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	spin_lock_irqsave(&qdev->hw_lock, flags);
 
 	if (qdev->current_page != 0)
-		ql_set_register_page(qdev,0);
+		ql_set_register_page(qdev, 0);
 	value = readl(reg);
 
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 	return value;
 }
 
 static u32 ql_read_page0_reg(struct ql3_adapter *qdev, u32 __iomem *reg)
 {
 	if (qdev->current_page != 0)
-		ql_set_register_page(qdev,0);
+		ql_set_register_page(qdev, 0);
 	return readl(reg);
 }
 
 static void ql_write_common_reg_l(struct ql3_adapter *qdev,
 				u32 __iomem *reg, u32 value)
 {
-	unsigned long hw_flags;
+	unsigned long flags;
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	spin_lock_irqsave(&qdev->hw_lock, flags);
 	writel(value, reg);
 	readl(reg);
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
-	return;
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 }
 
 static void ql_write_common_reg(struct ql3_adapter *qdev,
@@ -230,7 +222,6 @@ static void ql_write_common_reg(struct q
 {
 	writel(value, reg);
 	readl(reg);
-	return;
 }
 
 static void ql_write_nvram_reg(struct ql3_adapter *qdev,
@@ -239,17 +230,21 @@ static void ql_write_nvram_reg(struct ql
 	writel(value, reg);
 	readl(reg);
 	udelay(1);
-	return;
 }
 
-static void ql_write_page0_reg(struct ql3_adapter *qdev,
-			       u32 __iomem *reg, u32 value)
+static void ql_write_page_reg(struct ql3_adapter *qdev,
+			      u32 __iomem *reg, u32 value, unsigned int page)
 {
-	if (qdev->current_page != 0)
-		ql_set_register_page(qdev,0);
+	if (qdev->current_page != page)
+		ql_set_register_page(qdev, page);
 	writel(value, reg);
 	readl(reg);
-	return;
+}
+
+static void ql_write_page0_reg(struct ql3_adapter *qdev,
+			       u32 __iomem *reg, u32 value)
+{
+	ql_write_page_reg(qdev, reg, value, 0);
 }
 
 /*
@@ -258,11 +253,7 @@ static void ql_write_page0_reg(struct ql
 static void ql_write_page1_reg(struct ql3_adapter *qdev,
 			       u32 __iomem *reg, u32 value)
 {
-	if (qdev->current_page != 1)
-		ql_set_register_page(qdev,1);
-	writel(value, reg);
-	readl(reg);
-	return;
+	ql_write_page_reg(qdev, reg, value, 1);
 }
 
 /*
@@ -271,29 +262,21 @@ static void ql_write_page1_reg(struct ql
 static void ql_write_page2_reg(struct ql3_adapter *qdev,
 			       u32 __iomem *reg, u32 value)
 {
-	if (qdev->current_page != 2)
-		ql_set_register_page(qdev,2);
-	writel(value, reg);
-	readl(reg);
-	return;
+	ql_write_page_reg(qdev, reg, value, 2);
 }
 
 static void ql_disable_interrupts(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
-
-	ql_write_common_reg_l(qdev, &port_regs->CommonRegs.ispInterruptMaskReg,
-			    (ISP_IMR_ENABLE_INT << 16));
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.ispInterruptMaskReg;
 
+	ql_write_common_reg_l(qdev, reg, ISP_IMR_ENABLE_INT << 16);
 }
 
 static void ql_enable_interrupts(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
-
-	ql_write_common_reg_l(qdev, &port_regs->CommonRegs.ispInterruptMaskReg,
-			    ((0xff << 16) | ISP_IMR_ENABLE_INT));
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.ispInterruptMaskReg;
 
+	ql_write_common_reg_l(qdev, reg, (0xff << 16) | ISP_IMR_ENABLE_INT);
 }
 
 static void ql_release_to_lrg_buf_free_list(struct ql3_adapter *qdev,
@@ -356,10 +339,11 @@ static void ql_release_to_lrg_buf_free_l
 static struct ql_rcv_buf_cb *ql_get_from_lrg_buf_free_list(struct ql3_adapter
 							   *qdev)
 {
-	struct ql_rcv_buf_cb *lrg_buf_cb;
+	struct ql_rcv_buf_cb *lrg_buf_cb = qdev->lrg_buf_free_head;
 
-	if ((lrg_buf_cb = qdev->lrg_buf_free_head) != NULL) {
-		if ((qdev->lrg_buf_free_head = lrg_buf_cb->next) == NULL)
+	if (lrg_buf_cb) {
+		qdev->lrg_buf_free_head = lrg_buf_cb->next;
+		if (!qdev->lrg_buf_free_head)
 			qdev->lrg_buf_free_tail = NULL;
 		qdev->lrg_buf_free_count--;
 	}
@@ -367,26 +351,17 @@ static struct ql_rcv_buf_cb *ql_get_from
 	return lrg_buf_cb;
 }
 
-static u32 addrBits = EEPROM_NO_ADDR_BITS;
-static u32 dataBits = EEPROM_NO_DATA_BITS;
-
-static void fm93c56a_deselect(struct ql3_adapter *qdev);
-static void eeprom_readword(struct ql3_adapter *qdev, u32 eepromAddr,
-			    unsigned short *value);
-
 /*
  * Caller holds hw_lock.
  */
 static void fm93c56a_select(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.serialPortInterfaceReg;
 
 	qdev->eeprom_cmd_data = AUBURN_EEPROM_CS_1;
-	ql_write_nvram_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    ISP_NVRAM_MASK | qdev->eeprom_cmd_data);
-	ql_write_nvram_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    ((ISP_NVRAM_MASK << 16) | qdev->eeprom_cmd_data));
+	ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK | qdev->eeprom_cmd_data);
+	ql_write_nvram_reg(qdev, reg,
+			   (ISP_NVRAM_MASK << 16) | qdev->eeprom_cmd_data);
 }
 
 /*
@@ -394,90 +369,64 @@ static void fm93c56a_select(struct ql3_a
  */
 static void fm93c56a_cmd(struct ql3_adapter *qdev, u32 cmd, u32 eepromAddr)
 {
-	int i;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.serialPortInterfaceReg;
 	u32 mask;
-	u32 dataBit;
 	u32 previousBit;
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	unsigned int i;
 
 	/* Clock in a zero, then do the start bit */
-	ql_write_nvram_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    ISP_NVRAM_MASK | qdev->eeprom_cmd_data |
-			    AUBURN_EEPROM_DO_1);
-	ql_write_nvram_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    ISP_NVRAM_MASK | qdev->
-			    eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
-			    AUBURN_EEPROM_CLK_RISE);
-	ql_write_nvram_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    ISP_NVRAM_MASK | qdev->
-			    eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
-			    AUBURN_EEPROM_CLK_FALL);
+	ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK | qdev->eeprom_cmd_data |
+			   AUBURN_EEPROM_DO_1);
+	ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK | qdev->eeprom_cmd_data |
+			   AUBURN_EEPROM_DO_1 | AUBURN_EEPROM_CLK_RISE);
+	ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK | qdev->eeprom_cmd_data |
+			   AUBURN_EEPROM_DO_1 | AUBURN_EEPROM_CLK_FALL);
 
 	mask = 1 << (FM93C56A_CMD_BITS - 1);
 	/* Force the previous data bit to be different */
 	previousBit = 0xffff;
 	for (i = 0; i < FM93C56A_CMD_BITS; i++) {
-		dataBit =
+		u32 dataBit =
 		    (cmd & mask) ? AUBURN_EEPROM_DO_1 : AUBURN_EEPROM_DO_0;
 		if (previousBit != dataBit) {
 			/*
 			 * If the bit changed, then change the DO state to
 			 * match
 			 */
-			ql_write_nvram_reg(qdev,
-					    &port_regs->CommonRegs.
-					    serialPortInterfaceReg,
-					    ISP_NVRAM_MASK | qdev->
-					    eeprom_cmd_data | dataBit);
+			ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+					   qdev->eeprom_cmd_data | dataBit);
 			previousBit = dataBit;
 		}
-		ql_write_nvram_reg(qdev,
-				    &port_regs->CommonRegs.
-				    serialPortInterfaceReg,
-				    ISP_NVRAM_MASK | qdev->
-				    eeprom_cmd_data | dataBit |
-				    AUBURN_EEPROM_CLK_RISE);
-		ql_write_nvram_reg(qdev,
-				    &port_regs->CommonRegs.
-				    serialPortInterfaceReg,
-				    ISP_NVRAM_MASK | qdev->
-				    eeprom_cmd_data | dataBit |
-				    AUBURN_EEPROM_CLK_FALL);
+		ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+				   qdev->eeprom_cmd_data | dataBit |
+				   AUBURN_EEPROM_CLK_RISE);
+		ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+				   qdev->eeprom_cmd_data | dataBit |
+				   AUBURN_EEPROM_CLK_FALL);
 		cmd = cmd << 1;
 	}
 
-	mask = 1 << (addrBits - 1);
+	mask = 1 << (EEPROM_NO_ADDR_BITS - 1);
 	/* Force the previous data bit to be different */
 	previousBit = 0xffff;
-	for (i = 0; i < addrBits; i++) {
-		dataBit =
-		    (eepromAddr & mask) ? AUBURN_EEPROM_DO_1 :
-		    AUBURN_EEPROM_DO_0;
+	for (i = 0; i < EEPROM_NO_ADDR_BITS; i++) {
+		u32 dataBit = (eepromAddr & mask) ?
+		    AUBURN_EEPROM_DO_1 : AUBURN_EEPROM_DO_0;
 		if (previousBit != dataBit) {
 			/*
 			 * If the bit changed, then change the DO state to
 			 * match
 			 */
-			ql_write_nvram_reg(qdev,
-					    &port_regs->CommonRegs.
-					    serialPortInterfaceReg,
-					    ISP_NVRAM_MASK | qdev->
-					    eeprom_cmd_data | dataBit);
+			ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+					   qdev->eeprom_cmd_data | dataBit);
 			previousBit = dataBit;
 		}
-		ql_write_nvram_reg(qdev,
-				    &port_regs->CommonRegs.
-				    serialPortInterfaceReg,
-				    ISP_NVRAM_MASK | qdev->
-				    eeprom_cmd_data | dataBit |
-				    AUBURN_EEPROM_CLK_RISE);
-		ql_write_nvram_reg(qdev,
-				    &port_regs->CommonRegs.
-				    serialPortInterfaceReg,
-				    ISP_NVRAM_MASK | qdev->
-				    eeprom_cmd_data | dataBit |
-				    AUBURN_EEPROM_CLK_FALL);
+		ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+				   qdev-> eeprom_cmd_data | dataBit |
+				   AUBURN_EEPROM_CLK_RISE);
+		ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+				   qdev->eeprom_cmd_data | dataBit |
+				   AUBURN_EEPROM_CLK_FALL);
 		eepromAddr = eepromAddr << 1;
 	}
 }
@@ -487,11 +436,10 @@ static void fm93c56a_cmd(struct ql3_adap
  */
 static void fm93c56a_deselect(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.serialPortInterfaceReg;
+
 	qdev->eeprom_cmd_data = AUBURN_EEPROM_CS_0;
-	ql_write_nvram_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    ISP_NVRAM_MASK | qdev->eeprom_cmd_data);
+	ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK | qdev->eeprom_cmd_data);
 }
 
 /*
@@ -499,31 +447,23 @@ static void fm93c56a_deselect(struct ql3
  */
 static void fm93c56a_datain(struct ql3_adapter *qdev, unsigned short *value)
 {
-	int i;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.serialPortInterfaceReg;
+	unsigned int i;
 	u32 data = 0;
-	u32 dataBit;
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
 
 	/* Read the data bits */
 	/* The first bit is a dummy.  Clock right over it. */
-	for (i = 0; i < dataBits; i++) {
-		ql_write_nvram_reg(qdev,
-				    &port_regs->CommonRegs.
-				    serialPortInterfaceReg,
-				    ISP_NVRAM_MASK | qdev->eeprom_cmd_data |
-				    AUBURN_EEPROM_CLK_RISE);
-		ql_write_nvram_reg(qdev,
-				    &port_regs->CommonRegs.
-				    serialPortInterfaceReg,
-				    ISP_NVRAM_MASK | qdev->eeprom_cmd_data |
-				    AUBURN_EEPROM_CLK_FALL);
-		dataBit =
-		    (ql_read_common_reg
-		     (qdev,
-		      &port_regs->CommonRegs.
-		      serialPortInterfaceReg) & AUBURN_EEPROM_DI_1) ? 1 : 0;
-		data = (data << 1) | dataBit;
+	for (i = 0; i < EEPROM_NO_DATA_BITS; i++) {
+		u32 dataBit;
+
+		ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+				   qdev->eeprom_cmd_data |
+				   AUBURN_EEPROM_CLK_RISE);
+		ql_write_nvram_reg(qdev, reg, ISP_NVRAM_MASK |
+				   qdev->eeprom_cmd_data |
+				   AUBURN_EEPROM_CLK_FALL);
+		dataBit = ql_read_common_reg(qdev, reg) & AUBURN_EEPROM_DI_1;
+		data = ((data ? 1 : 0) << 1) | dataBit;
 	}
 	*value = (u16) data;
 }
@@ -558,22 +498,22 @@ #endif
 
 static int ql_get_nvram_params(struct ql3_adapter *qdev)
 {
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 10;
+	unsigned long flags;
 	u16 *pEEPROMData;
 	u16 checksum = 0;
 	u32 index;
-	unsigned long hw_flags;
+	int rc;
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	spin_lock_irqsave(&qdev->hw_lock, flags);
 
-	pEEPROMData = (u16 *) & qdev->nvram_data;
+	pEEPROMData = (u16 *) &qdev->nvram_data;
 	qdev->eeprom_cmd_data = 0;
-	if(ql_sem_spinlock(qdev, QL_NVRAM_SEM_MASK,
-			(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index) *
-			 2) << 10)) {
+	rc = ql_sem_spinlock(qdev, QL_NVRAM_SEM_MASK, bits);
+	if (rc < 0) {
 		printk(KERN_ERR PFX"%s: Failed ql_sem_spinlock().\n",
 			__func__);
-		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
-		return -1;
+		goto out_unlock;
 	}
 
 	for (index = 0; index < EEPROM_SIZE; index++) {
@@ -586,8 +526,8 @@ static int ql_get_nvram_params(struct ql
 	if (checksum != 0) {
 		printk(KERN_ERR PFX "%s: checksum should be zero, is %x!!\n",
 		       qdev->ndev->name, checksum);
-		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
-		return -1;
+		rc = -EIO;
+		goto out_unlock;
 	}
 
 	/*
@@ -599,11 +539,13 @@ static int ql_get_nvram_params(struct ql
 	ql_swap_mac_addr(qdev->nvram_data.funcCfg_fn1.macAddress);
 	ql_swap_mac_addr(qdev->nvram_data.funcCfg_fn2.macAddress);
 	ql_swap_mac_addr(qdev->nvram_data.funcCfg_fn3.macAddress);
-	pEEPROMData = (u16 *) & qdev->nvram_data.version;
+	pEEPROMData = (u16 *) &qdev->nvram_data.version;
 	*pEEPROMData = le16_to_cpu(*pEEPROMData);
 
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
-	return checksum;
+out_unlock:
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
+
+	return rc;
 }
 
 static const u32 PHYAddr[2] = {
@@ -612,30 +554,28 @@ static const u32 PHYAddr[2] = {
 
 static int ql_wait_for_mii_ready(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
-	u32 temp;
-	int count = 1000;
+	u32 __iomem *reg = &qdev->ioaddr->macMIIStatusReg;
+	unsigned int i;
 
-	while (count) {
-		temp = ql_read_page0_reg(qdev, &port_regs->macMIIStatusReg);
-		if (!(temp & MAC_MII_STATUS_BSY))
+	for (i = 0; i < 1000; i++) {
+		if (!(ql_read_page0_reg(qdev, reg) & MAC_MII_STATUS_BSY))
 			return 0;
 		udelay(10);
-		count--;
 	}
 	return -1;
 }
 
+#define MAC_MII_CONTROL_SC_AS (MAC_MII_CONTROL_AS | MAC_MII_CONTROL_SC)
+
 static void ql_mii_enable_scan_mode(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *ctrl = &qdev->ioaddr->macMIIMgmtControlReg;
+	u32 __iomem *addr = &qdev->ioaddr->macMIIMgmtAddrReg;
 	u32 scanControl;
 
 	if (qdev->numPorts > 1) {
 		/* Auto scan will cycle through multiple ports */
-		scanControl = MAC_MII_CONTROL_AS | MAC_MII_CONTROL_SC;
+		scanControl = MAC_MII_CONTROL_SC_AS;
 	} else {
 		scanControl = MAC_MII_CONTROL_SC;
 	}
@@ -646,40 +586,27 @@ static void ql_mii_enable_scan_mode(stru
 	 * The autoscan starts from the first register, completes
 	 * the last one before rolling over to the first
 	 */
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtAddrReg,
-			   PHYAddr[0] | MII_SCAN_REGISTER);
-
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
-			   (scanControl) |
-			   ((MAC_MII_CONTROL_SC | MAC_MII_CONTROL_AS) << 16));
+	ql_write_page0_reg(qdev, addr, PHYAddr[0] | MII_SCAN_REGISTER);
+	ql_write_page0_reg(qdev, ctrl,
+			   scanControl | (MAC_MII_CONTROL_SC_AS << 16));
 }
 
 static u8 ql_mii_disable_scan_mode(struct ql3_adapter *qdev)
 {
+	u32 __iomem *ctrl = &qdev->ioaddr->macMIIMgmtControlReg;
+	u32 __iomem *addr = &qdev->ioaddr->macMIIMgmtAddrReg;
 	u8 ret;
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    				qdev->mem_map_registers;
-
-	/* See if scan mode is enabled before we turn it off */
-	if (ql_read_page0_reg(qdev, &port_regs->macMIIMgmtControlReg) &
-	    (MAC_MII_CONTROL_AS | MAC_MII_CONTROL_SC)) {
-		/* Scan is enabled */
-		ret = 1;
-	} else {
-		/* Scan is disabled */
-		ret = 0;
-	}
+
+	/* See if scan mode is enabled (1) or not (0) before we turn it off */
+	ret = (ql_read_page0_reg(qdev, ctrl) & MAC_MII_CONTROL_SC_AS) ? 1 : 0;
 
 	/*
 	 * When disabling scan mode you must first change the MII register
 	 * address
 	 */
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtAddrReg,
-			   PHYAddr[0] | MII_SCAN_REGISTER);
-
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
-			   ((MAC_MII_CONTROL_SC | MAC_MII_CONTROL_AS |
-			     MAC_MII_CONTROL_RC) << 16));
+	ql_write_page0_reg(qdev, addr, PHYAddr[0] | MII_SCAN_REGISTER);
+	ql_write_page0_reg(qdev, ctrl,
+			   (MAC_MII_CONTROL_SC_AS | MAC_MII_CONTROL_RC) << 16);
 
 	return ret;
 }
@@ -687,33 +614,40 @@ static u8 ql_mii_disable_scan_mode(struc
 static int ql_mii_write_reg_ex(struct ql3_adapter *qdev,
 			       u16 regAddr, u16 value, u32 phyAddr)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *addr = &qdev->ioaddr->macMIIMgmtAddrReg;
+	u32 __iomem *data = &qdev->ioaddr->macMIIMgmtDataReg;
 	u8 scanWasEnabled;
 
 	scanWasEnabled = ql_mii_disable_scan_mode(qdev);
 
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s Timed out waiting for management port to "
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtAddrReg,
 			   phyAddr | regAddr);
 
 	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtDataReg, value);
+=======
+	ql_write_page0_reg(qdev, addr, PHYAddr[mac_index] | regAddr);
+	ql_write_page0_reg(qdev, data, value);
+>>>>>>> /drivers/net/qla3xxx.c
 
 	/* Wait for write to complete 9/10/04 SJP */
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to"
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
@@ -726,19 +660,19 @@ static int ql_mii_write_reg_ex(struct ql
 static int ql_mii_read_reg_ex(struct ql3_adapter *qdev, u16 regAddr,
 			      u16 * value, u32 phyAddr)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	u8 scanWasEnabled;
 	u32 temp;
 
 	scanWasEnabled = ql_mii_disable_scan_mode(qdev);
 
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to "
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
@@ -746,18 +680,19 @@ static int ql_mii_read_reg_ex(struct ql3
 			   phyAddr | regAddr);
 
 	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
-			   (MAC_MII_CONTROL_RC << 16));
+			   MAC_MII_CONTROL_RC << 16);
 
 	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
 			   (MAC_MII_CONTROL_RC << 16) | MAC_MII_CONTROL_RC);
 
 	/* Wait for the read to complete */
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to "
 			       "get free after issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
@@ -772,32 +707,32 @@ static int ql_mii_read_reg_ex(struct ql3
 
 static int ql_mii_write_reg(struct ql3_adapter *qdev, u16 regAddr, u16 value)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *addr = &qdev->ioaddr->macMIIMgmtAddrReg;
+	u32 __iomem *data = &qdev->ioaddr->macMIIMgmtDataReg;
 
 	ql_mii_disable_scan_mode(qdev);
 
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to "
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtAddrReg,
-			   qdev->PHYAddr | regAddr);
-
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtDataReg, value);
+	ql_write_page0_reg(qdev, addr, qdev->PHYAddr | regAddr);
+	ql_write_page0_reg(qdev, data, value);
 
 	/* Wait for write to complete. */
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to "
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
@@ -808,18 +743,18 @@ static int ql_mii_write_reg(struct ql3_a
 
 static int ql_mii_read_reg(struct ql3_adapter *qdev, u16 regAddr, u16 *value)
 {
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	u32 temp;
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
 
 	ql_mii_disable_scan_mode(qdev);
 
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to "
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
@@ -827,18 +762,19 @@ static int ql_mii_read_reg(struct ql3_ad
 			   qdev->PHYAddr | regAddr);
 
 	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
-			   (MAC_MII_CONTROL_RC << 16));
+			   MAC_MII_CONTROL_RC << 16);
 
 	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
 			   (MAC_MII_CONTROL_RC << 16) | MAC_MII_CONTROL_RC);
 
 	/* Wait for the read to complete */
 	if (ql_wait_for_mii_ready(qdev)) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Timed out waiting for management port to "
 			       "get free before issuing command.\n",
 			       qdev->ndev->name);
+		}
 		return -1;
 	}
 
@@ -1009,8 +945,12 @@ static int ql_phy_get_speed(struct ql3_a
 	if (ql_mii_read_reg(qdev, AUX_CONTROL_STATUS, &reg) < 0)
 		return 0;
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	reg = (((reg & 0x18) >> 3) & 3);
 	}
+=======
+	reg = ((reg & 0x18) >> 3) & 3;
+>>>>>>> /drivers/net/qla3xxx.c
 
 	switch(reg) {
 		case 2:
@@ -1128,14 +1068,11 @@ static int PHY_Setup(struct ql3_adapter 
  */
 static void ql_mac_enable(struct ql3_adapter *qdev, u32 enable)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
-	u32 value;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
+	u32 value = MAC_CONFIG_REG_PE << 16;
 
 	if (enable)
-		value = (MAC_CONFIG_REG_PE | (MAC_CONFIG_REG_PE << 16));
-	else
-		value = (MAC_CONFIG_REG_PE << 16);
+		value |= MAC_CONFIG_REG_PE;
 
 	if (qdev->mac_index)
 		ql_write_page0_reg(qdev, &port_regs->mac1ConfigReg, value);
@@ -1148,14 +1085,11 @@ static void ql_mac_enable(struct ql3_ada
  */
 static void ql_mac_cfg_soft_reset(struct ql3_adapter *qdev, u32 enable)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
-	u32 value;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
+	u32 value = MAC_CONFIG_REG_SR << 16;
 
 	if (enable)
-		value = (MAC_CONFIG_REG_SR | (MAC_CONFIG_REG_SR << 16));
-	else
-		value = (MAC_CONFIG_REG_SR << 16);
+		value |= MAC_CONFIG_REG_SR;
 
 	if (qdev->mac_index)
 		ql_write_page0_reg(qdev, &port_regs->mac1ConfigReg, value);
@@ -1168,14 +1102,11 @@ static void ql_mac_cfg_soft_reset(struct
  */
 static void ql_mac_cfg_gig(struct ql3_adapter *qdev, u32 enable)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
-	u32 value;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
+	u32 value = MAC_CONFIG_REG_GM << 16;
 
 	if (enable)
-		value = (MAC_CONFIG_REG_GM | (MAC_CONFIG_REG_GM << 16));
-	else
-		value = (MAC_CONFIG_REG_GM << 16);
+		value |= MAC_CONFIG_REG_GM;
 
 	if (qdev->mac_index)
 		ql_write_page0_reg(qdev, &port_regs->mac1ConfigReg, value);
@@ -1188,14 +1119,11 @@ static void ql_mac_cfg_gig(struct ql3_ad
  */
 static void ql_mac_cfg_full_dup(struct ql3_adapter *qdev, u32 enable)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
-	u32 value;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
+	u32 value = MAC_CONFIG_REG_FD << 16;
 
 	if (enable)
-		value = (MAC_CONFIG_REG_FD | (MAC_CONFIG_REG_FD << 16));
-	else
-		value = (MAC_CONFIG_REG_FD << 16);
+		value |= MAC_CONFIG_REG_FD;
 
 	if (qdev->mac_index)
 		ql_write_page0_reg(qdev, &port_regs->mac1ConfigReg, value);
@@ -1208,8 +1136,7 @@ static void ql_mac_cfg_full_dup(struct q
  */
 static void ql_mac_cfg_pause(struct ql3_adapter *qdev, u32 enable)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	u32 value;
 
 	if (enable)
@@ -1230,8 +1157,7 @@ static void ql_mac_cfg_pause(struct ql3_
  */
 static int ql_is_fiber(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	u32 bitToCheck = 0;
 	u32 temp;
 
@@ -1260,8 +1186,7 @@ static int ql_is_auto_cfg(struct ql3_ada
  */
 static int ql_is_auto_neg_complete(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	u32 bitToCheck = 0;
 	u32 temp;
 
@@ -1276,16 +1201,18 @@ static int ql_is_auto_neg_complete(struc
 
 	temp = ql_read_page0_reg(qdev, &port_regs->portStatus);
 	if (temp & bitToCheck) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_INFO PFX
 			       "%s: Auto-Negotiate complete.\n",
 			       qdev->ndev->name);
+		}
 		return 1;
 	} else {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Auto-Negotiate incomplete.\n",
 			       qdev->ndev->name);
+		}
 		return 0;
 	}
 }
@@ -1303,8 +1230,7 @@ static int ql_is_neg_pause(struct ql3_ad
 
 static int ql_auto_neg_error(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	u32 bitToCheck = 0;
 	u32 temp;
 
@@ -1341,10 +1267,8 @@ static int ql_is_link_full_dup(struct ql
  */
 static int ql_link_down_detect(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.ispControlStatus;
 	u32 bitToCheck = 0;
-	u32 temp;
 
 	switch (qdev->mac_index) {
 	case 0:
@@ -1355,9 +1279,7 @@ static int ql_link_down_detect(struct ql
 		break;
 	}
 
-	temp =
-	    ql_read_common_reg(qdev, &port_regs->CommonRegs.ispControlStatus);
-	return (temp & bitToCheck) != 0;
+	return (ql_read_common_reg(qdev, reg) & bitToCheck) != 0;
 }
 
 /*
@@ -1365,21 +1287,16 @@ static int ql_link_down_detect(struct ql
  */
 static int ql_link_down_detect_clear(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.ispControlStatus;
 
 	switch (qdev->mac_index) {
 	case 0:
-		ql_write_common_reg(qdev,
-				    &port_regs->CommonRegs.ispControlStatus,
-				    (ISP_CONTROL_LINK_DN_0) |
+		ql_write_common_reg(qdev, reg, ISP_CONTROL_LINK_DN_0 |
 				    (ISP_CONTROL_LINK_DN_0 << 16));
 		break;
 
 	case 1:
-		ql_write_common_reg(qdev,
-				    &port_regs->CommonRegs.ispControlStatus,
-				    (ISP_CONTROL_LINK_DN_1) |
+		ql_write_common_reg(qdev, reg, ISP_CONTROL_LINK_DN_1 |
 				    (ISP_CONTROL_LINK_DN_1 << 16));
 		break;
 
@@ -1395,8 +1312,6 @@ static int ql_link_down_detect_clear(str
  */
 static int ql_this_adapter_controls_port(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
 	u32 bitToCheck = 0;
 	u32 temp;
 
@@ -1411,16 +1326,18 @@ static int ql_this_adapter_controls_port
 		break;
 	}
 
-	temp = ql_read_page0_reg(qdev, &port_regs->portStatus);
+	temp = ql_read_page0_reg(qdev, &qdev->ioaddr->portStatus);
 	if (temp & bitToCheck) {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_DEBUG PFX
 			       "%s: is not link master.\n", qdev->ndev->name);
+		}
 		return 0;
 	} else {
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_DEBUG PFX
 			       "%s: is link master.\n", qdev->ndev->name);
+		}
 		return 1;
 	}
 }
@@ -1522,8 +1439,6 @@ static void ql_phy_init_ex(struct ql3_ad
  */
 static u32 ql_get_link_state(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
 	u32 bitToCheck = 0;
 	u32 temp, linkState;
 
@@ -1535,20 +1450,22 @@ static u32 ql_get_link_state(struct ql3_
 		bitToCheck = PORT_STATUS_UP1;
 		break;
 	}
-	temp = ql_read_page0_reg(qdev, &port_regs->portStatus);
+	temp = ql_read_page0_reg(qdev, &qdev->ioaddr->portStatus);
 	if (temp & bitToCheck) {
 		linkState = LS_UP;
 	} else {
 		linkState = LS_DOWN;
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_WARNING PFX
 			       "%s: Link is down.\n", qdev->ndev->name);
+		}
 	}
 	return linkState;
 }
 
 static int ql_port_start(struct ql3_adapter *qdev)
 {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
 		(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index) *
 			 2) << 7)) {
@@ -1556,6 +1473,14 @@ static int ql_port_start(struct ql3_adap
 		       qdev->ndev->name);
 		return -1;
 	}
+=======
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 7;
+	int rc;
+
+	rc = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK, bits);
+	if (rc < 0)
+		goto out;
+>>>>>>> /drivers/net/qla3xxx.c
 
 	if (ql_is_fiber(qdev)) {
 		ql_petbi_init(qdev);
@@ -1565,123 +1490,125 @@ static int ql_port_start(struct ql3_adap
 	}
 
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-	return 0;
+out:
+	return rc;
 }
 
 static int ql_finish_auto_neg(struct ql3_adapter *qdev)
 {
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 7;
+	int rc;
 
-	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
-		(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index) *
-			 2) << 7))
-		return -1;
+	rc = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK, bits);
+	if (rc < 0)
+		goto out;
 
 	if (!ql_auto_neg_error(qdev)) {
 		if (test_bit(QL_LINK_MASTER,&qdev->flags)) {
 			/* configure the MAC */
-			if (netif_msg_link(qdev))
-				printk(KERN_DEBUG PFX
-				       "%s: Configuring link.\n",
-				       qdev->ndev->
-				       name);
+			if (netif_msg_link(qdev)) {
+				printk(KERN_DEBUG PFX "%s: Configuring link.\n",
+				       qdev->ndev->name);
+			}
 			ql_mac_cfg_soft_reset(qdev, 1);
 			ql_mac_cfg_gig(qdev,
-				       (ql_get_link_speed
-					(qdev) ==
-					SPEED_1000));
-			ql_mac_cfg_full_dup(qdev,
-					    ql_is_link_full_dup
-					    (qdev));
-			ql_mac_cfg_pause(qdev,
-					 ql_is_neg_pause
-					 (qdev));
+				       (ql_get_link_speed(qdev) == SPEED_1000));
+			ql_mac_cfg_full_dup(qdev, ql_is_link_full_dup(qdev));
+			ql_mac_cfg_pause(qdev, ql_is_neg_pause(qdev));
 			ql_mac_cfg_soft_reset(qdev, 0);
 
 			/* enable the MAC */
-			if (netif_msg_link(qdev))
-				printk(KERN_DEBUG PFX
-				       "%s: Enabling mac.\n",
-				       qdev->ndev->
-					       name);
+			if (netif_msg_link(qdev)) {
+				printk(KERN_DEBUG PFX "%s: Enabling mac.\n",
+				       qdev->ndev->name);
+			}
 			ql_mac_enable(qdev, 1);
 		}
 
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_DEBUG PFX
 			       "%s: Change port_link_state LS_DOWN to LS_UP.\n",
 			       qdev->ndev->name);
+		}
 		qdev->port_link_state = LS_UP;
 		netif_start_queue(qdev->ndev);
 		netif_carrier_on(qdev->ndev);
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_INFO PFX
 			       "%s: Link is up at %d Mbps, %s duplex.\n",
 			       qdev->ndev->name,
 			       ql_get_link_speed(qdev),
 			       ql_is_link_full_dup(qdev)
 			       ? "full" : "half");
-
+		}
 	} else {	/* Remote error detected */
 
-		if (test_bit(QL_LINK_MASTER,&qdev->flags)) {
-			if (netif_msg_link(qdev))
+		if (test_bit(QL_LINK_MASTER, &qdev->flags)) {
+			if (netif_msg_link(qdev)) {
 				printk(KERN_DEBUG PFX
 				       "%s: Remote error detected. "
 				       "Calling ql_port_start().\n",
-				       qdev->ndev->
-				       name);
+				       qdev->ndev->name);
+			}
 			/*
 			 * ql_port_start() is shared code and needs
 			 * to lock the PHY on it's own.
 			 */
 			ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-			if(ql_port_start(qdev))	{/* Restart port */
+			if (ql_port_start(qdev))	{/* Restart port */
 				return -1;
 			} else
 				return 0;
 		}
 	}
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-	return 0;
+out:
+	return rc;
 }
 
 static void ql_link_state_machine(struct ql3_adapter *qdev)
 {
 	u32 curr_link_state;
-	unsigned long hw_flags;
+	unsigned long flags;
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	spin_lock_irqsave(&qdev->hw_lock, flags);
 
 	curr_link_state = ql_get_link_state(qdev);
 
-	if (test_bit(QL_RESET_ACTIVE,&qdev->flags)) {
-		if (netif_msg_link(qdev))
+	if (test_bit(QL_RESET_ACTIVE, &qdev->flags)) {
+		if (netif_msg_link(qdev)) {
 			printk(KERN_INFO PFX
 			       "%s: Reset in progress, skip processing link "
 			       "state.\n", qdev->ndev->name);
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 
 		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);		
+=======
+		}
+		/* FIXME: return with spinlock held. */
+>>>>>>> /drivers/net/qla3xxx.c
 		return;
 	}
 
 	switch (qdev->port_link_state) {
 	default:
-		if (test_bit(QL_LINK_MASTER,&qdev->flags)) {
+		if (test_bit(QL_LINK_MASTER, &qdev->flags))
 			ql_port_start(qdev);
-		}
 		qdev->port_link_state = LS_DOWN;
 		/* Fall Through */
 
 	case LS_DOWN:
-		if (netif_msg_link(qdev))
+		if (netif_msg_link(qdev)) {
 			printk(KERN_DEBUG PFX
 			       "%s: port_link_state = LS_DOWN.\n",
 			       qdev->ndev->name);
+		}
 		if (curr_link_state == LS_UP) {
-			if (netif_msg_link(qdev))
+			if (netif_msg_link(qdev)) {
 				printk(KERN_DEBUG PFX
 				       "%s: curr_link_state = LS_UP.\n",
 				       qdev->ndev->name);
+			}
 			if (ql_is_auto_neg_complete(qdev))
 				ql_finish_auto_neg(qdev);
 
@@ -1697,14 +1624,15 @@ static void ql_link_state_machine(struct
 		 * back up
 		 */
 		if ((curr_link_state == LS_DOWN) || ql_link_down_detect(qdev)) {
-			if (netif_msg_link(qdev))
+			if (netif_msg_link(qdev)) {
 				printk(KERN_INFO PFX "%s: Link is down.\n",
 				       qdev->ndev->name);
+			}
 			qdev->port_link_state = LS_DOWN;
 		}
 		break;
 	}
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 }
 
 /*
@@ -1712,10 +1640,15 @@ static void ql_link_state_machine(struct
  */
 static void ql_get_phy_owner(struct ql3_adapter *qdev)
 {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (ql_this_adapter_controls_port(qdev))
 		set_bit(QL_LINK_MASTER,&qdev->flags);
+=======
+	if (ql_this_adapter_controls_port(qdev, qdev->mac_index))
+		set_bit(QL_LINK_MASTER, &qdev->flags);
+>>>>>>> /drivers/net/qla3xxx.c
 	else
-		clear_bit(QL_LINK_MASTER,&qdev->flags);
+		clear_bit(QL_LINK_MASTER, &qdev->flags);
 }
 
 /*
@@ -1725,9 +1658,15 @@ static void ql_init_scan_mode(struct ql3
 {
 	ql_mii_enable_scan_mode(qdev);
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (test_bit(QL_LINK_OPTICAL,&qdev->flags)) {
 		if (ql_this_adapter_controls_port(qdev))
 			ql_petbi_init_ex(qdev);
+=======
+	if (test_bit(QL_LINK_OPTICAL, &qdev->flags)) {
+		if (ql_this_adapter_controls_port(qdev, qdev->mac_index))
+			ql_petbi_init_ex(qdev, qdev->mac_index);
+>>>>>>> /drivers/net/qla3xxx.c
 	} else {
 		if (ql_this_adapter_controls_port(qdev))
 			ql_phy_init_ex(qdev);
@@ -1742,52 +1681,54 @@ static void ql_init_scan_mode(struct ql3
  */
 static int ql_mii_setup(struct ql3_adapter *qdev)
 {
-	u32 reg;
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 7;
+	u32 __iomem *ctrl = &qdev->ioaddr->macMIIMgmtControlReg;
+	int rc;
 
-	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
-			(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index) *
-			 2) << 7))
-		return -1;
+	rc = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK, bits);
+	if (rc < 0)
+		goto out;
+
+	if (qdev->device_id == QL3032_DEVICE_ID)
+		ql_write_page0_reg(qdev, ctrl, 0x0f00000);
 
 	if (qdev->device_id == QL3032_DEVICE_ID)
 		ql_write_page0_reg(qdev, 
 			&port_regs->macMIIMgmtControlReg, 0x0f00000);
 
 	/* Divide 125MHz clock by 28 to meet PHY timing requirements */
-	reg = MAC_MII_CONTROL_CLK_SEL_DIV28;
-
-	ql_write_page0_reg(qdev, &port_regs->macMIIMgmtControlReg,
-			   reg | ((MAC_MII_CONTROL_CLK_SEL_MASK) << 16));
+	ql_write_page0_reg(qdev, ctrl, MAC_MII_CONTROL_CLK_SEL_DIV28 |
+			   (MAC_MII_CONTROL_CLK_SEL_MASK << 16));
 
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-	return 0;
+out:
+	return rc;
 }
 
 static u32 ql_supported_modes(struct ql3_adapter *qdev)
 {
 	u32 supported;
 
-	if (test_bit(QL_LINK_OPTICAL,&qdev->flags)) {
-		supported = SUPPORTED_1000baseT_Full | SUPPORTED_FIBRE
-		    | SUPPORTED_Autoneg;
+	if (test_bit(QL_LINK_OPTICAL, &qdev->flags)) {
+		supported = SUPPORTED_1000baseT_Full | SUPPORTED_FIBRE |
+			SUPPORTED_Autoneg;
 	} else {
-		supported = SUPPORTED_10baseT_Half
-		    | SUPPORTED_10baseT_Full
-		    | SUPPORTED_100baseT_Half
-		    | SUPPORTED_100baseT_Full
-		    | SUPPORTED_1000baseT_Half
-		    | SUPPORTED_1000baseT_Full
-		    | SUPPORTED_Autoneg | SUPPORTED_TP;
+		supported = SUPPORTED_Autoneg | SUPPORTED_TP |
+			SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full |
+			SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full |
+			SUPPORTED_1000baseT_Half | SUPPORTED_1000baseT_Full;
 	}
 
 	return supported;
 }
 
+// FIXME: the caller does not check the returned value.
 static int ql_get_auto_cfg_status(struct ql3_adapter *qdev)
 {
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 7;
+	unsigned long flags;
 	int status;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	unsigned long hw_flags;
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
@@ -1796,15 +1737,31 @@ static int ql_get_auto_cfg_status(struct
 		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 		return 0;
 	}
+=======
+	int rc;
+
+	spin_lock_irqsave(&qdev->hw_lock, flags);
+
+	rc = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK, bits);
+	if (rc < 0) {
+		status = 0;
+		goto out_unlock;
+	}
+>>>>>>> /drivers/net/qla3xxx.c
 	status = ql_is_auto_cfg(qdev);
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+out_unlock:
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 	return status;
 }
 
+// FIXME: the caller does not check the returned value.
 static u32 ql_get_speed(struct ql3_adapter *qdev)
 {
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 7;
+	unsigned long flags;
 	u32 status;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	unsigned long hw_flags;
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
@@ -1813,15 +1770,30 @@ static u32 ql_get_speed(struct ql3_adapt
 		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 		return 0;
 	}
+=======
+	int rc;
+
+	spin_lock_irqsave(&qdev->hw_lock, flags);
+	rc = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK, bits);
+	if (rc < 0) {
+		status = 0;
+		goto out_unlock;
+	}
+>>>>>>> /drivers/net/qla3xxx.c
 	status = ql_get_link_speed(qdev);
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+out_unlock:
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 	return status;
 }
 
+// FIXME: the caller does not check the returned value.
 static int ql_get_full_dup(struct ql3_adapter *qdev)
 {
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 7;
+	unsigned long flags;
 	int status;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	unsigned long hw_flags;
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
@@ -1830,9 +1802,20 @@ static int ql_get_full_dup(struct ql3_ad
 		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 		return 0;
 	}
+=======
+	int rc;
+
+	spin_lock_irqsave(&qdev->hw_lock, flags);
+	rc = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK, bits);
+	if (rc < 0) {
+		status = 0;
+		goto out_unlock;
+	}
+>>>>>>> /drivers/net/qla3xxx.c
 	status = ql_is_link_full_dup(qdev);
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+out_unlock:
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 	return status;
 }
 
@@ -1844,7 +1827,7 @@ static int ql_get_settings(struct net_de
 	ecmd->transceiver = XCVR_INTERNAL;
 	ecmd->supported = ql_supported_modes(qdev);
 
-	if (test_bit(QL_LINK_OPTICAL,&qdev->flags)) {
+	if (test_bit(QL_LINK_OPTICAL, &qdev->flags)) {
 		ecmd->port = PORT_FIBRE;
 	} else {
 		ecmd->port = PORT_TP;
@@ -1861,6 +1844,7 @@ static void ql_get_drvinfo(struct net_de
 			   struct ethtool_drvinfo *drvinfo)
 {
 	struct ql3_adapter *qdev = netdev_priv(ndev);
+
 	strncpy(drvinfo->driver, ql3xxx_driver_name, 32);
 	strncpy(drvinfo->version, ql3xxx_driver_version, 32);
 	strncpy(drvinfo->fw_version, "N/A", 32);
@@ -1874,12 +1858,14 @@ static void ql_get_drvinfo(struct net_de
 static u32 ql_get_msglevel(struct net_device *ndev)
 {
 	struct ql3_adapter *qdev = netdev_priv(ndev);
+
 	return qdev->msg_enable;
 }
 
 static void ql_set_msglevel(struct net_device *ndev, u32 value)
 {
 	struct ql3_adapter *qdev = netdev_priv(ndev);
+
 	qdev->msg_enable = value;
 }
 
@@ -1911,10 +1897,21 @@ static const struct ethtool_ops ql3xxx_e
 
 static int ql_populate_free_queue(struct ql3_adapter *qdev)
 {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	struct ql_rcv_buf_cb *lrg_buf_cb = qdev->lrg_buf_free_head;
 	dma_addr_t map;
 	int err;
+=======
+	struct ql_rcv_buf_cb *rx_cb;
+
+	for (rx_cb = qdev->lrg_buf_free_head; rx_cb; rx_cb = rx_cb->next) {
+		u64 map;
 
+		if (rx_cb->skb)
+			continue;
+>>>>>>> /drivers/net/qla3xxx.c
+
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	while (lrg_buf_cb) {
 		if (!lrg_buf_cb->skb) {
 			lrg_buf_cb->skb = netdev_alloc_skb(qdev->ndev,
@@ -1958,8 +1955,33 @@ static int ql_populate_free_queue(struct
 				if (!qdev->lrg_buf_skb_check)
 					return 1;
 			}
+=======
+		rx_cb->skb = dev_alloc_skb(qdev->lrg_buffer_len);
+		if (unlikely(!rx_cb->skb)) {
+			printk(KERN_DEBUG PFX "%s: Failed dev_alloc_skb().\n",
+			       qdev->ndev->name);
+			break;
+>>>>>>> /drivers/net/qla3xxx.c
 		}
-		lrg_buf_cb = lrg_buf_cb->next;
+		/*
+		 * We save some space to copy the ethhdr from
+		 * first buffer
+		 */
+		skb_reserve(rx_cb->skb, QL_HEADER_SPACE);
+		map = pci_map_single(qdev->pdev, rx_cb->skb->data,
+				     qdev->lrg_buffer_len - QL_HEADER_SPACE,
+				     PCI_DMA_FROMDEVICE);
+
+		rx_cb->buf_phy_addr_low  = cpu_to_le32(LS_64BITS(map));
+		rx_cb->buf_phy_addr_high = cpu_to_le32(MS_64BITS(map));
+
+		pci_unmap_addr_set(rx_cb, mapaddr, map);
+		pci_unmap_len_set(rx_cb, maplen,
+				  qdev->lrg_buffer_len - QL_HEADER_SPACE);
+
+		--qdev->lrg_buf_skb_check;
+		if (!qdev->lrg_buf_skb_check)
+			return 1;
 	}
 	return 0;
 }
@@ -1990,13 +2012,12 @@ static void ql_update_small_bufq_prod_in
  */
 static void ql_update_lrg_bufq_prod_index(struct ql3_adapter *qdev)
 {
+	u32 __iomem *idx = &qdev->ioaddr->CommonRegs.rxLargeQProducerIndex;
 	struct bufq_addr_element *lrg_buf_q_ele;
-	int i;
 	struct ql_rcv_buf_cb *lrg_buf_cb;
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
 
-	if ((qdev->lrg_buf_free_count >= 8)
-	    && (qdev->lrg_buf_release_cnt >= 16)) {
+	if ((qdev->lrg_buf_free_count >= 8) &&
+	    (qdev->lrg_buf_release_cnt >= 16)) {
 
 		if (qdev->lrg_buf_skb_check)
 			if (!ql_populate_free_queue(qdev))
@@ -2004,8 +2025,9 @@ static void ql_update_lrg_bufq_prod_inde
 
 		lrg_buf_q_ele = qdev->lrg_buf_next_free;
 
-		while ((qdev->lrg_buf_release_cnt >= 16)
-		       && (qdev->lrg_buf_free_count >= 8)) {
+		while ((qdev->lrg_buf_release_cnt >= 16) &&
+		       (qdev->lrg_buf_free_count >= 8)) {
+			unsigned int i;
 
 			for (i = 0; i < 8; i++) {
 				lrg_buf_cb =
@@ -2031,18 +2053,29 @@ static void ql_update_lrg_bufq_prod_inde
 		}
 		wmb();
 		qdev->lrg_buf_next_free = lrg_buf_q_ele;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 		writel(qdev->lrg_buf_q_producer_index,
 			&port_regs->CommonRegs.rxLargeQProducerIndex);
+=======
+
+		ql_write_common_reg(qdev, idx, qdev->lrg_buf_q_producer_index);
+>>>>>>> /drivers/net/qla3xxx.c
 	}
 }
 
 static void ql_process_mac_tx_intr(struct ql3_adapter *qdev,
 				   struct ob_mac_iocb_rsp *mac_rsp)
 {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	struct ql_tx_buf_cb *tx_cb;
 	int i;
 	int retval = 0;
+=======
+	struct ql_tx_buf_cb *tx_cb = &qdev->tx_buf[mac_rsp->transaction_id];
+	unsigned int i;
+>>>>>>> /drivers/net/qla3xxx.c
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if(mac_rsp->flags & OB_MAC_IOCB_RSP_S) {
 		printk(KERN_WARNING "Frame short but, frame was padded and sent.\n");
 	}
@@ -2080,17 +2113,31 @@ static void ql_process_mac_tx_intr(struc
 				       PCI_DMA_TODEVICE);
 		}
 	}
+=======
+	for (i = 0; !i || (i < tx_cb->seg_count); i++) {
+		pci_unmap_page(qdev->pdev,
+			       pci_unmap_addr(tx_cb->map + i, mapaddr),
+			       pci_unmap_len(tx_cb->map + i, maplen),
+			       PCI_DMA_TODEVICE);
+	}
+	tx_cb->seg_count--;
+>>>>>>> /drivers/net/qla3xxx.c
 	qdev->stats.tx_packets++;
 	qdev->stats.tx_bytes += tx_cb->skb->len;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 
 frame_not_sent:
 	dev_kfree_skb_irq(tx_cb->skb);
+=======
+	dev_kfree_skb_irq(tx_cb->skb);
+>>>>>>> /drivers/net/qla3xxx.c
 	tx_cb->skb = NULL;
 
 invalid_seg_count:
 	atomic_inc(&qdev->tx_count);
 }
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 static void ql_get_sbuf(struct ql3_adapter *qdev)
 {
 	if (++qdev->small_buf_index == NUM_SMALL_BUFFERS)
@@ -2120,6 +2167,20 @@ static struct ql_rcv_buf_cb *ql_get_lbuf
  * simpler process.  3032 also supports checksum verification as
  * can be seen in ql_process_macip_rx_intr().
  */
+=======
+/*
+ * The difference between 3022 and 3032 for inbound completions:
+ * 3022 uses two buffers per completion.  The first buffer contains 
+ * (some) header info, the second the remainder of the headers plus 
+ * the data.  For this chip we reserve some space at the top of the 
+ * receive buffer so that the header info in buffer one can be 
+ * prepended to the buffer two.  Buffer two is the sent up while 
+ * buffer one is returned to the hardware to be reused.
+ * 3032 receives all of it's data and headers in one buffer for a 
+ * simpler process.  3032 also supports checksum verification as
+ * can be seen in ql_process_macip_rx_intr().
+ */
+>>>>>>> /drivers/net/qla3xxx.c
 static void ql_process_mac_rx_intr(struct ql3_adapter *qdev,
 				   struct ib_mac_iocb_rsp *ib_mac_rsp_ptr)
 {
@@ -2133,8 +2194,26 @@ static void ql_process_mac_rx_intr(struc
 	 */
 	ql_get_sbuf(qdev);
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (qdev->device_id == QL3022_DEVICE_ID)
 		lrg_buf_cb1 = ql_get_lbuf(qdev);
+=======
+	curr_ial_ptr = (u32 *) (qdev->small_buf_virt_addr + offset);
+	qdev->last_rsp_offset = qdev->small_buf_phy_addr_low + offset;
+	qdev->small_buf_release_cnt++;
+
+	if (qdev->device_id == QL3022_DEVICE_ID) {
+		/* start of first buffer (3022 only) */
+		lrg_buf_phy_addr_low = le32_to_cpu(*curr_ial_ptr);
+		lrg_buf_cb1 = &qdev->lrg_buf[qdev->lrg_buf_index];
+		qdev->lrg_buf_release_cnt++;
+		if (++qdev->lrg_buf_index == NUM_LARGE_BUFFERS) {
+			qdev->lrg_buf_index = 0;
+		}
+		curr_ial_ptr++;	/* 64-bit pointers require two incs. */
+		curr_ial_ptr++;
+	}
+>>>>>>> /drivers/net/qla3xxx.c
 
 	/* start of second buffer */
 	lrg_buf_cb2 = ql_get_lbuf(qdev);
@@ -2166,7 +2245,12 @@ static void ql_process_macip_rx_intr(str
 {
 	struct ql_rcv_buf_cb *lrg_buf_cb1 = NULL;
 	struct ql_rcv_buf_cb *lrg_buf_cb2 = NULL;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
+	struct sk_buff *skb1 = NULL, *skb2;
+=======
+	u32 *curr_ial_ptr;
 	struct sk_buff *skb1 = NULL, *skb2;
+>>>>>>> /drivers/net/qla3xxx.c
 	struct net_device *ndev = qdev->ndev;
 	u16 length = le16_to_cpu(ib_ip_rsp_ptr->length);
 	u16 size = 0;
@@ -2177,6 +2261,7 @@ static void ql_process_macip_rx_intr(str
 
 	ql_get_sbuf(qdev);
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (qdev->device_id == QL3022_DEVICE_ID) {
 		/* start of first buffer on 3022 */
 		lrg_buf_cb1 = ql_get_lbuf(qdev);
@@ -2185,11 +2270,34 @@ static void ql_process_macip_rx_intr(str
 		if (*((u16 *) skb1->data) != 0xFFFF)
 			size += VLAN_ETH_HLEN - ETH_HLEN;
 	}
+=======
+	if (qdev->device_id == QL3022_DEVICE_ID) {
+		/* start of first buffer on 3022 */
+		lrg_buf_phy_addr_low = le32_to_cpu(*curr_ial_ptr);
+		lrg_buf_cb1 = &qdev->lrg_buf[qdev->lrg_buf_index];
+		qdev->lrg_buf_release_cnt++;
+		if (++qdev->lrg_buf_index == NUM_LARGE_BUFFERS)
+			qdev->lrg_buf_index = 0;
+		skb1 = lrg_buf_cb1->skb;
+		curr_ial_ptr++;	/* 64-bit pointers require two incs. */
+		curr_ial_ptr++;
+		size = ETH_HLEN;
+		if (*((u16 *) skb1->data) != 0xFFFF)
+			size += VLAN_ETH_HLEN - ETH_HLEN;
+	}
+>>>>>>> /drivers/net/qla3xxx.c
 
 	/* start of second buffer */
 	lrg_buf_cb2 = ql_get_lbuf(qdev);
 	skb2 = lrg_buf_cb2->skb;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 
+=======
+	qdev->lrg_buf_release_cnt++;
+	if (++qdev->lrg_buf_index == NUM_LARGE_BUFFERS)
+		qdev->lrg_buf_index = 0;
+
+>>>>>>> /drivers/net/qla3xxx.c
 	skb_put(skb2, length);	/* Just the second buffer length here. */
 	pci_unmap_single(qdev->pdev,
 			 pci_unmap_addr(lrg_buf_cb2, mapaddr),
@@ -2197,6 +2305,7 @@ static void ql_process_macip_rx_intr(str
 			 PCI_DMA_FROMDEVICE);
 	prefetch(skb2->data);
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	skb2->ip_summed = CHECKSUM_NONE;
 	if (qdev->device_id == QL3022_DEVICE_ID) {
 		/*
@@ -2222,6 +2331,32 @@ static void ql_process_macip_rx_intr(str
 			skb2->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 	}
+=======
+	skb2->ip_summed = CHECKSUM_NONE;
+	if (qdev->device_id == QL3022_DEVICE_ID) {
+		/*
+		 * Copy the ethhdr from first buffer to second. This
+		 * is necessary for 3022 IP completions.
+		 */
+		memcpy(skb_push(skb2, size), skb1->data + VLAN_ID_LEN, size);
+	} else {
+		u16 checksum = le16_to_cpu(ib_ip_rsp_ptr->checksum);
+		if (checksum & 
+			(IB_IP_IOCB_RSP_3032_ICE | 
+			 IB_IP_IOCB_RSP_3032_CE | 
+			 IB_IP_IOCB_RSP_3032_NUC)) {
+			printk(KERN_ERR
+			       "%s: Bad checksum for this %s packet, checksum = %x.\n",
+			       __func__,
+			       ((checksum & 
+				IB_IP_IOCB_RSP_3032_TCP) ? "TCP" :
+				"UDP"),checksum);
+		} else if (checksum & IB_IP_IOCB_RSP_3032_TCP) {
+			skb2->ip_summed = CHECKSUM_UNNECESSARY;
+		} 
+	}
+	skb2->dev = qdev->ndev;
+>>>>>>> /drivers/net/qla3xxx.c
 	skb2->protocol = eth_type_trans(skb2, qdev->ndev);
 
 	netif_receive_skb(skb2);
@@ -2238,15 +2373,29 @@ static void ql_process_macip_rx_intr(str
 static int ql_tx_rx_clean(struct ql3_adapter *qdev,
 			  int *tx_cleaned, int *rx_cleaned, int work_to_do)
 {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	struct net_rsp_iocb *net_rsp;
+=======
+	struct ql3xxx_common_registers __iomem *regs =
+		&qdev->ioaddr->CommonRegs;
+>>>>>>> /drivers/net/qla3xxx.c
 	struct net_device *ndev = qdev->ndev;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	int work_done = 0;
+=======
+	unsigned long flags;
+>>>>>>> /drivers/net/qla3xxx.c
 
 	/* While there are entries in the completion queue. */
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	while ((le32_to_cpu(*(qdev->prsp_producer_index)) !=
 		qdev->rsp_consumer_index) && (work_done < work_to_do)) {
+=======
+	while ((cpu_to_le32(*(qdev->prsp_producer_index)) !=
+		qdev->rsp_consumer_index) && (*rx_cleaned < work_to_do)) {
+		struct net_rsp_iocb *net_rsp = qdev->rsp_current;
+>>>>>>> /drivers/net/qla3xxx.c
 
-		net_rsp = qdev->rsp_current;
 		switch (net_rsp->opcode) {
 
 		case OPCODE_OB_MAC_IOCB_FN0:
@@ -2273,8 +2422,7 @@ static int ql_tx_rx_clean(struct ql3_ada
 			{
 				u32 *tmp = (u32 *) net_rsp;
 				printk(KERN_ERR PFX
-				       "%s: Hit default case, not "
-				       "handled!\n"
+				       "%s: Hit default case, not handled!\n"
 				       "	dropping the packet, opcode = "
 				       "%x.\n",
 				       ndev->name, net_rsp->opcode);
@@ -2295,11 +2443,48 @@ static int ql_tx_rx_clean(struct ql3_ada
 		} else {
 			qdev->rsp_current++;
 		}
+<<<<<<< HEAD/drivers/net/qla3xxx.c
+=======
+	}
+
+	spin_lock_irqsave(&qdev->hw_lock, flags);
+
+	ql_update_lrg_bufq_prod_index(qdev);
+
+	if (qdev->small_buf_release_cnt >= 16) {
+		while (qdev->small_buf_release_cnt >= 16) {
+			qdev->small_buf_q_producer_index++;
 
+			if (qdev->small_buf_q_producer_index ==
+			    NUM_SBUFQ_ENTRIES)
+				qdev->small_buf_q_producer_index = 0;
+			qdev->small_buf_release_cnt -= 8;
+		}
+>>>>>>> /drivers/net/qla3xxx.c
+
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 		work_done = *tx_cleaned + *rx_cleaned;
+=======
+		ql_write_common_reg(qdev, &regs->rxSmallQProducerIndex,
+				    qdev->small_buf_q_producer_index);
+>>>>>>> /drivers/net/qla3xxx.c
 	}
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	return work_done;
+=======
+	ql_write_common_reg(qdev, &regs->rspQConsumerIndex,
+			    qdev->rsp_consumer_index);
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
+
+	if (unlikely(netif_queue_stopped(ndev))) {
+		if (netif_queue_stopped(ndev) &&
+		    (atomic_read(&qdev->tx_count) > (NUM_REQ_Q_ENTRIES / 4)))
+			netif_wake_queue(ndev);
+	}
+
+	return *tx_cleaned + *rx_cleaned;
+>>>>>>> /drivers/net/qla3xxx.c
 }
 
 static int ql_poll(struct net_device *ndev, int *budget)
@@ -2337,48 +2522,45 @@ quit_polling:
 
 static irqreturn_t ql3xxx_isr(int irq, void *dev_id)
 {
-
 	struct net_device *ndev = dev_id;
 	struct ql3_adapter *qdev = netdev_priv(ndev);
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
+	u32 __iomem *ctl = &qdev->ioaddr->CommonRegs.ispControlStatus;
+	unsigned int handled = 1;
 	u32 value;
-	int handled = 1;
-	u32 var;
-
-	port_regs = qdev->mem_map_registers;
 
-	value =
-	    ql_read_common_reg_l(qdev, &port_regs->CommonRegs.ispControlStatus);
+	value = ql_read_common_reg_l(qdev, ctl);
 
 	if (value & (ISP_CONTROL_FE | ISP_CONTROL_RI)) {
 		spin_lock(&qdev->adapter_lock);
+
 		netif_stop_queue(qdev->ndev);
 		netif_carrier_off(qdev->ndev);
 		ql_disable_interrupts(qdev);
 		qdev->port_link_state = LS_DOWN;
-		set_bit(QL_RESET_ACTIVE,&qdev->flags) ;
+		set_bit(QL_RESET_ACTIVE, &qdev->flags) ;
 
 		if (value & ISP_CONTROL_FE) {
 			/*
 			 * Chip Fatal Error.
 			 */
-			var =
-			    ql_read_page0_reg_l(qdev,
-					      &port_regs->PortFatalErrStatus);
+			u32 __iomem *reg = &qdev->ioaddr->PortFatalErrStatus;
+			u32 var = ql_read_page0_reg_l(qdev, reg);
+
 			printk(KERN_WARNING PFX
 			       "%s: Resetting chip. PortFatalErrStatus "
 			       "register = 0x%x\n", ndev->name, var);
-			set_bit(QL_RESET_START,&qdev->flags) ;
+			set_bit(QL_RESET_START, &qdev->flags) ;
 		} else {
 			/*
 			 * Soft Reset Requested.
 			 */
-			set_bit(QL_RESET_PER_SCSI,&qdev->flags) ;
+			set_bit(QL_RESET_PER_SCSI, &qdev->flags) ;
 			printk(KERN_ERR PFX
 			       "%s: Another function issued a reset to the "
 			       "chip. ISR value = %x.\n", ndev->name, value);
 		}
 		queue_delayed_work(qdev->workqueue, &qdev->reset_work, 0);
+
 		spin_unlock(&qdev->adapter_lock);
 	} else if (value & ISP_IMR_DISABLE_CMPL_INT) {
 		ql_disable_interrupts(qdev);
@@ -2392,6 +2574,7 @@ static irqreturn_t ql3xxx_isr(int irq, v
 	return IRQ_RETVAL(handled);
 }
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 /*
  * Get the total number of segments needed for the 
  * given number of fragments.  This is necessary because
@@ -2605,17 +2788,104 @@ map_error:
  * The IOCB is always the top of the chain followed by one or more 
  * OALs (when necessary).
  */
+=======
+/*
+ * Get the total number of segments needed for the 
+ * given number of fragments.  This is necessary because
+ * outbound address lists (OAL) will be used when more than
+ * two frags are given.  Each address list has 5 addr/len 
+ * pairs.  The 5th pair in each AOL is used to  point to
+ * the next AOL if more frags are coming.  
+ * That is why the frags:segment count  ratio is not linear.
+ */
+static int ql_get_seg_count(unsigned short frags)
+{
+	switch(frags) {
+	case 0:	return 1;	/* just the skb->data seg */
+	case 1:	return 2;	/* skb->data + 1 frag */
+	case 2:	return 3;	/* skb->data + 2 frags */
+	case 3:	return 5;	/* skb->data + 1 frag + 1 AOL containting 2 frags */
+	case 4:	return 6;
+	case 5:	return 7;
+	case 6:	return 8;
+	case 7:	return 10;
+	case 8:	return 11;
+	case 9:	return 12;
+	case 10: return 13;
+	case 11: return 15;
+	case 12: return 16;
+	case 13: return 17;
+	case 14: return 18;
+	case 15: return 20;
+	case 16: return 21;
+	case 17: return 22;
+	case 18: return 23;
+	}
+	return -1;
+}
+
+static void ql_hw_csum_setup(struct sk_buff *skb,
+			     struct ob_mac_iocb_req *mac_iocb_ptr)
+{
+	struct ethhdr *eth = (struct ethhdr *) skb->data;
+
+	struct iphdr *ip = NULL;
+	u8 offset = ETH_HLEN;
+
+	if (eth->h_proto == __constant_htons(ETH_P_IP)) {
+		ip = (struct iphdr *)&skb->data[ETH_HLEN];
+	} else if (eth->h_proto == htons(ETH_P_8021Q) &&
+		   ((struct vlan_ethhdr *)skb->data)->
+		   h_vlan_encapsulated_proto == __constant_htons(ETH_P_IP)) {
+		ip = (struct iphdr *)&skb->data[VLAN_ETH_HLEN];
+		offset = VLAN_ETH_HLEN;
+	}
+
+	if (ip) {
+		if (ip->protocol == IPPROTO_TCP) {
+			mac_iocb_ptr->flags1 |= OB_3032MAC_IOCB_REQ_TC;
+			mac_iocb_ptr->ip_hdr_off = offset;
+			mac_iocb_ptr->ip_hdr_len = ip->ihl;
+		} else if (ip->protocol == IPPROTO_UDP) {
+			mac_iocb_ptr->flags1 |= OB_3032MAC_IOCB_REQ_UC;
+			mac_iocb_ptr->ip_hdr_off = offset;
+			mac_iocb_ptr->ip_hdr_len = ip->ihl;
+		}
+	}
+}
+
+/*
+ * The difference between 3022 and 3032 sends:
+ * 3022 only supports a simple single segment transmission.
+ * 3032 supports checksumming and scatter/gather lists (fragments).
+ * The 3032 supports sglists by using the 3 addr/len pairs (ALP) 
+ * in the IOCB plus a chain of outbound address lists (OAL) that 
+ * each contain 5 ALPs.  The last ALP of the IOCB (3rd) or OAL (5th) 
+ * will used to point to an OAL when more ALP entries are required.  
+ * The IOCB is always the top of the chain followed by one or more 
+ * OALs (when necessary).
+ */
+>>>>>>> /drivers/net/qla3xxx.c
 static int ql3xxx_send(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct ql3_adapter *qdev = (struct ql3_adapter *)netdev_priv(ndev);
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
+	struct ql3_adapter *qdev = netdev_priv(ndev);
+	u32 __iomem *idx = &qdev->ioaddr->CommonRegs.reqQProducerIndex;
+	int frag_cnt = (int)skb_shinfo(skb)->nr_frags;
+	struct ob_mac_iocb_req *mac_iocb_ptr;
+	struct oal_entry *oal_entry;
 	struct ql_tx_buf_cb *tx_cb;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	u32 tot_len = skb->len;
 	struct ob_mac_iocb_req *mac_iocb_ptr;
+=======
+	unsigned int len;
+	u64 map;
+>>>>>>> /drivers/net/qla3xxx.c
 
 	if (unlikely(atomic_read(&qdev->tx_count) < 2)) {
 		return NETDEV_TX_BUSY;
 	}
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	
 	tx_cb = &qdev->tx_buf[qdev->req_producer_index] ;
 	if((tx_cb->seg_count = ql_get_seg_count(qdev,
@@ -2624,14 +2894,26 @@ static int ql3xxx_send(struct sk_buff *s
 		return NETDEV_TX_OK;
 	}
 	
+=======
+
+	tx_cb = &qdev->tx_buf[qdev->req_producer_index];
+	tx_cb->seg_count = ql_get_seg_count((skb_shinfo(skb)->nr_frags));
+	if (tx_cb->seg_count == -1) {
+		printk(KERN_ERR PFX"%s: invalid segment count!\n",__func__);
+		return NETDEV_TX_OK;
+
+	}
+
+>>>>>>> /drivers/net/qla3xxx.c
 	mac_iocb_ptr = tx_cb->queue_entry;
-	memset((void *)mac_iocb_ptr, 0, sizeof(struct ob_mac_iocb_req));
+	memset(mac_iocb_ptr, 0, sizeof(struct ob_mac_iocb_req));
 	mac_iocb_ptr->opcode = qdev->mac_ob_opcode;
 	mac_iocb_ptr->flags = OB_MAC_IOCB_REQ_X;
 	mac_iocb_ptr->flags |= qdev->mb_bit_mask;
 	mac_iocb_ptr->transaction_id = qdev->req_producer_index;
 	mac_iocb_ptr->data_len = cpu_to_le16((u16) tot_len);
 	tx_cb->skb = skb;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (qdev->device_id == QL3032_DEVICE_ID &&
 	    skb->ip_summed == CHECKSUM_PARTIAL)
 		ql_hw_csum_setup(skb, mac_iocb_ptr);
@@ -2642,18 +2924,83 @@ static int ql3xxx_send(struct sk_buff *s
 	}
 	
 	wmb();
+=======
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		ql_hw_csum_setup(skb, mac_iocb_ptr);
+
+	len = skb_headlen(skb);
+	map = pci_map_single(qdev->pdev, skb->data, len, PCI_DMA_TODEVICE);
+	oal_entry = (struct oal_entry *)&mac_iocb_ptr->buf_addr0_low;
+	oal_entry->dma_lo = cpu_to_le32(LS_64BITS(map));
+	oal_entry->dma_hi = cpu_to_le32(MS_64BITS(map));
+	oal_entry->len = cpu_to_le32(len);
+
+	pci_unmap_addr_set(tx_cb->map, mapaddr, map);
+	pci_unmap_len_set(tx_cb->map, maplen, len);
+
+	if (frag_cnt) {
+		const int seg_cnt = tx_cb->seg_count;
+		struct oal *oal = tx_cb->oal;
+		unsigned int seg;
+		unsigned int i;
+
+		for (i = 0, seg = 1; i < frag_cnt; i++, seg++) {
+			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+			oal_entry++;
+			/*
+			 * Check for continuation requirements. It's strange
+			 * but necessary.
+			 */
+			if ((seg == 2 && seg_cnt > 3) ||
+			    (seg == 7 && seg_cnt > 8) ||
+			    (seg == 12 && seg_cnt > 13) ||
+			    (seg == 17 && seg_cnt > 18)) {
+				/* Continuation entry points to outbound address list. */
+				map = pci_map_single(qdev->pdev, oal,
+						     sizeof(struct oal),
+						     PCI_DMA_TODEVICE);
+				oal_entry->dma_lo = cpu_to_le32(LS_64BITS(map));
+				oal_entry->dma_hi = cpu_to_le32(MS_64BITS(map));
+				oal_entry->len =
+				    cpu_to_le32(sizeof(struct oal) |
+						OAL_CONT_ENTRY);
+				pci_unmap_addr_set(&tx_cb->map[seg], mapaddr,
+						   map);
+				pci_unmap_len_set(&tx_cb->map[seg], maplen,
+						  len);
+				oal_entry = (struct oal_entry *)oal;
+				oal++;
+				seg++;
+			}
+
+			map = pci_map_page(qdev->pdev, frag->page,
+					   frag->page_offset, frag->size,
+					   PCI_DMA_TODEVICE);
+			oal_entry->dma_lo = cpu_to_le32(LS_64BITS(map));
+			oal_entry->dma_hi = cpu_to_le32(MS_64BITS(map));
+			oal_entry->len = cpu_to_le32(frag->size);
+			pci_unmap_addr_set(&tx_cb->map[seg], mapaddr, map);
+			pci_unmap_len_set(&tx_cb->map[seg], maplen,
+					  frag->size);
+		}
+	}
+
+	/* Terminate the last segment */
+	len = le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY;
+	oal_entry->len = cpu_to_le32(len);
+	wmb();
+>>>>>>> /drivers/net/qla3xxx.c
 	qdev->req_producer_index++;
 	if (qdev->req_producer_index == NUM_REQ_Q_ENTRIES)
 		qdev->req_producer_index = 0;
 	wmb();
-	ql_write_common_reg_l(qdev,
-			    &port_regs->CommonRegs.reqQProducerIndex,
-			    qdev->req_producer_index);
+	ql_write_common_reg_l(qdev, idx, qdev->req_producer_index);
 
 	ndev->trans_start = jiffies;
-	if (netif_msg_tx_queued(qdev))
+	if (netif_msg_tx_queued(qdev)) {
 		printk(KERN_DEBUG PFX "%s: tx queued, slot %d, len %d\n",
 		       ndev->name, qdev->req_producer_index, skb->len);
+	}
 
 	atomic_dec(&qdev->tx_count);
 	return NETDEV_TX_OK;
@@ -2694,14 +3041,14 @@ static int ql_alloc_net_req_rsp_queues(s
 		return -ENOMEM;
 	}
 
-	set_bit(QL_ALLOC_REQ_RSP_Q_DONE,&qdev->flags);
+	set_bit(QL_ALLOC_REQ_RSP_Q_DONE, &qdev->flags);
 
 	return 0;
 }
 
 static void ql_free_net_req_rsp_queues(struct ql3_adapter *qdev)
 {
-	if (!test_bit(QL_ALLOC_REQ_RSP_Q_DONE,&qdev->flags)) {
+	if (!test_bit(QL_ALLOC_REQ_RSP_Q_DONE, &qdev->flags)) {
 		printk(KERN_INFO PFX
 		       "%s: Already done.\n", qdev->ndev->name);
 		return;
@@ -2719,7 +3066,7 @@ static void ql_free_net_req_rsp_queues(s
 
 	qdev->rsp_q_virt_addr = NULL;
 
-	clear_bit(QL_ALLOC_REQ_RSP_Q_DONE,&qdev->flags);
+	clear_bit(QL_ALLOC_REQ_RSP_Q_DONE, &qdev->flags);
 }
 
 static int ql_alloc_buffer_queues(struct ql3_adapter *qdev)
@@ -2777,15 +3124,14 @@ static int ql_alloc_buffer_queues(struct
 
 	qdev->small_buf_q_virt_addr = qdev->small_buf_q_alloc_virt_addr;
 	qdev->small_buf_q_phy_addr = qdev->small_buf_q_alloc_phy_addr;
-	set_bit(QL_ALLOC_BUFQS_DONE,&qdev->flags);
+	set_bit(QL_ALLOC_BUFQS_DONE, &qdev->flags);
 	return 0;
 }
 
 static void ql_free_buffer_queues(struct ql3_adapter *qdev)
 {
-	if (!test_bit(QL_ALLOC_BUFQS_DONE,&qdev->flags)) {
-		printk(KERN_INFO PFX
-		       "%s: Already done.\n", qdev->ndev->name);
+	if (!test_bit(QL_ALLOC_BUFQS_DONE, &qdev->flags)) {
+		printk(KERN_INFO PFX "%s: Already done.\n", qdev->ndev->name);
 		return;
 	}
 	if(qdev->lrg_buf) kfree(qdev->lrg_buf);
@@ -2803,13 +3149,13 @@ static void ql_free_buffer_queues(struct
 
 	qdev->small_buf_q_virt_addr = NULL;
 
-	clear_bit(QL_ALLOC_BUFQS_DONE,&qdev->flags);
+	clear_bit(QL_ALLOC_BUFQS_DONE, &qdev->flags);
 }
 
 static int ql_alloc_small_buffers(struct ql3_adapter *qdev)
 {
-	int i;
 	struct bufq_addr_element *small_buf_q_entry;
+	unsigned int i;
 
 	/* Currently we allocate on one of memory and use it for smallbuffers */
 	qdev->small_buf_total_size =
@@ -2822,8 +3168,7 @@ static int ql_alloc_small_buffers(struct
 				 &qdev->small_buf_phy_addr);
 
 	if (qdev->small_buf_virt_addr == NULL) {
-		printk(KERN_ERR PFX
-		       "%s: Failed to get small buffer memory.\n",
+		printk(KERN_ERR PFX "%s: Failed to get small buffer memory.\n",
 		       qdev->ndev->name);
 		return -ENOMEM;
 	}
@@ -2843,15 +3188,14 @@ static int ql_alloc_small_buffers(struct
 		small_buf_q_entry++;
 	}
 	qdev->small_buf_index = 0;
-	set_bit(QL_ALLOC_SMALL_BUF_DONE,&qdev->flags);
+	set_bit(QL_ALLOC_SMALL_BUF_DONE, &qdev->flags);
 	return 0;
 }
 
 static void ql_free_small_buffers(struct ql3_adapter *qdev)
 {
-	if (!test_bit(QL_ALLOC_SMALL_BUF_DONE,&qdev->flags)) {
-		printk(KERN_INFO PFX
-		       "%s: Already done.\n", qdev->ndev->name);
+	if (!test_bit(QL_ALLOC_SMALL_BUF_DONE, &qdev->flags)) {
+		printk(KERN_INFO PFX "%s: Already done.\n", qdev->ndev->name);
 		return;
 	}
 	if (qdev->small_buf_virt_addr != NULL) {
@@ -2866,8 +3210,8 @@ static void ql_free_small_buffers(struct
 
 static void ql_free_large_buffers(struct ql3_adapter *qdev)
 {
-	int i = 0;
 	struct ql_rcv_buf_cb *lrg_buf_cb;
+	unsigned int i;
 
 	for (i = 0; i < qdev->num_large_buffers; i++) {
 		lrg_buf_cb = &qdev->lrg_buf[i];
@@ -2886,9 +3230,9 @@ static void ql_free_large_buffers(struct
 
 static void ql_init_large_buffers(struct ql3_adapter *qdev)
 {
-	int i;
-	struct ql_rcv_buf_cb *lrg_buf_cb;
 	struct bufq_addr_element *buf_addr_ele = qdev->lrg_buf_q_virt_addr;
+	struct ql_rcv_buf_cb *lrg_buf_cb;
+	unsigned int i;
 
 	for (i = 0; i < qdev->num_large_buffers; i++) {
 		lrg_buf_cb = &qdev->lrg_buf[i];
@@ -2902,15 +3246,28 @@ static void ql_init_large_buffers(struct
 
 static int ql_alloc_large_buffers(struct ql3_adapter *qdev)
 {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	int i;
 	struct ql_rcv_buf_cb *lrg_buf_cb;
 	struct sk_buff *skb;
 	dma_addr_t map;
 	int err;
+=======
+	unsigned int i;
+>>>>>>> /drivers/net/qla3xxx.c
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	for (i = 0; i < qdev->num_large_buffers; i++) {
 		skb = netdev_alloc_skb(qdev->ndev,
 				       qdev->lrg_buffer_len);
+=======
+	for (i = 0; i < NUM_LARGE_BUFFERS; i++) {
+		struct ql_rcv_buf_cb *lrg_buf_cb = &qdev->lrg_buf[i];
+		struct sk_buff *skb;
+		u64 map;
+
+		skb = dev_alloc_skb(qdev->lrg_buffer_len);
+>>>>>>> /drivers/net/qla3xxx.c
 		if (unlikely(!skb)) {
 			/* Better luck next round */
 			printk(KERN_ERR PFX
@@ -2921,8 +3278,6 @@ static int ql_alloc_large_buffers(struct
 			ql_free_large_buffers(qdev);
 			return -ENOMEM;
 		} else {
-
-			lrg_buf_cb = &qdev->lrg_buf[i];
 			memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
 			lrg_buf_cb->index = i;
 			lrg_buf_cb->skb = skb;
@@ -2958,6 +3313,7 @@ static int ql_alloc_large_buffers(struct
 	return 0;
 }
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 static void ql_free_send_free_list(struct ql3_adapter *qdev)
 {
 	struct ql_tx_buf_cb *tx_cb;
@@ -2974,22 +3330,50 @@ static void ql_free_send_free_list(struc
 }
 
 static int ql_create_send_free_list(struct ql3_adapter *qdev)
+=======
+static void ql_free_send_free_list(struct ql3_adapter *qdev)
+>>>>>>> /drivers/net/qla3xxx.c
 {
-	struct ql_tx_buf_cb *tx_cb;
-	int i;
-	struct ob_mac_iocb_req *req_q_curr =
-					qdev->req_q_virt_addr;
+	unsigned int i;
+
+	for (i = 0; i < NUM_REQ_Q_ENTRIES; i++) {
+		struct ql_tx_buf_cb *tx_cb = &qdev->tx_buf[i];
+
+		if (tx_cb->oal) {
+			kfree(tx_cb->oal);
+			tx_cb->oal = NULL;
+		}
+		tx_cb++;
+	}
+}
+
+static int ql_create_send_free_list(struct ql3_adapter *qdev)
+{
+	struct ob_mac_iocb_req *req_q_curr = qdev->req_q_virt_addr;
+	unsigned int i;
 
 	/* Create free list of transmit buffers */
 	for (i = 0; i < NUM_REQ_Q_ENTRIES; i++) {
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 
 		tx_cb = &qdev->tx_buf[i];
+=======
+		struct ql_tx_buf_cb *tx_cb = &qdev->tx_buf[i];
+
+>>>>>>> /drivers/net/qla3xxx.c
 		tx_cb->skb = NULL;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 		tx_cb->queue_entry = req_q_curr;
 		req_q_curr++;
 		tx_cb->oal = kmalloc(512, GFP_KERNEL);
 		if (tx_cb->oal == NULL)
 			return -1;
+=======
+		tx_cb->queue_entry = req_q_curr++;
+		tx_cb->oal = kmalloc(512, GFP_KERNEL);
+		if (tx_cb->oal == NULL)
+			return -1;
+>>>>>>> /drivers/net/qla3xxx.c
 	}
 	return 0;
 }
@@ -3007,9 +3391,8 @@ static int ql_alloc_mem_resources(struct
 		qdev->num_lbufq_entries = JUMBO_NUM_LBUFQ_ENTRIES;
 		qdev->lrg_buffer_len = JUMBO_MTU_SIZE;
 	} else {
-		printk(KERN_ERR PFX
-		       "%s: Invalid mtu size.  Only 1500 and 9000 are accepted.\n",
-		       qdev->ndev->name);
+		printk(KERN_ERR PFX "%s: Invalid mtu size."
+		       " Only 1500 and 9000 are accepted.\n", qdev->ndev->name);
 		return -ENOMEM;
 	}
 	qdev->num_large_buffers = qdev->num_lbufq_entries * QL_ADDR_ELE_PER_BUFQ_ENTRY;
@@ -3046,15 +3429,13 @@ static int ql_alloc_mem_resources(struct
 	}
 
 	if (ql_alloc_net_req_rsp_queues(qdev) != 0) {
-		printk(KERN_ERR PFX
-		       "%s: ql_alloc_net_req_rsp_queues failed.\n",
+		printk(KERN_ERR PFX "%s: ql_alloc_net_req_rsp_queues failed.\n",
 		       qdev->ndev->name);
 		goto err_req_rsp;
 	}
 
 	if (ql_alloc_buffer_queues(qdev) != 0) {
-		printk(KERN_ERR PFX
-		       "%s: ql_alloc_buffer_queues failed.\n",
+		printk(KERN_ERR PFX "%s: ql_alloc_buffer_queues failed.\n",
 		       qdev->ndev->name);
 		goto err_buffer_queues;
 	}
@@ -3086,8 +3467,7 @@ err_small_buffers:
 err_buffer_queues:
 	ql_free_net_req_rsp_queues(qdev);
 err_req_rsp:
-	pci_free_consistent(qdev->pdev,
-			    PAGE_SIZE,
+	pci_free_consistent(qdev->pdev, PAGE_SIZE,
 			    qdev->shadow_reg_virt_addr,
 			    qdev->shadow_reg_phy_addr);
 
@@ -3102,8 +3482,7 @@ static void ql_free_mem_resources(struct
 	ql_free_buffer_queues(qdev);
 	ql_free_net_req_rsp_queues(qdev);
 	if (qdev->shadow_reg_virt_addr != NULL) {
-		pci_free_consistent(qdev->pdev,
-				    PAGE_SIZE,
+		pci_free_consistent(qdev->pdev, PAGE_SIZE,
 				    qdev->shadow_reg_virt_addr,
 				    qdev->shadow_reg_phy_addr);
 		qdev->shadow_reg_virt_addr = NULL;
@@ -3112,13 +3491,14 @@ static void ql_free_mem_resources(struct
 
 static int ql_init_misc_registers(struct ql3_adapter *qdev)
 {
+	u32 bits = (QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index * 2)) << 4;
 	struct ql3xxx_local_ram_registers __iomem *local_ram =
-	    (void __iomem *)qdev->mem_map_registers;
+	    (void __iomem *)qdev->ioaddr;
+	int rc;
 
-	if(ql_sem_spinlock(qdev, QL_DDR_RAM_SEM_MASK,
-			(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index) *
-			 2) << 4))
-		return -1;
+	rc = ql_sem_spinlock(qdev, QL_DDR_RAM_SEM_MASK, bits);
+	if (rc < 0)
+		goto out;
 
 	ql_write_page2_reg(qdev,
 			   &local_ram->bufletSize, qdev->nvram_data.bufletSize);
@@ -3165,37 +3545,41 @@ static int ql_init_misc_registers(struct
 			   &local_ram->maxDrbCount,
 			   qdev->nvram_data.drbTableSize);
 	ql_sem_unlock(qdev, QL_DDR_RAM_SEM_MASK);
-	return 0;
+out:
+	return rc;
 }
 
+// FIXME: ugly
 static int ql_adapter_initialize(struct ql3_adapter *qdev)
 {
 	u32 value;
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
 	struct ql3xxx_host_memory_registers __iomem *hmem_regs =
-						(void __iomem *)port_regs;
+		(void __iomem *)port_regs;
+	struct ql3xxx_common_registers __iomem *regs = &port_regs->CommonRegs;
+	unsigned int mac_index = qdev->mac_index;
 	u32 delay = 10;
 	int status = 0;
 
-	if(ql_mii_setup(qdev))
+	if (ql_mii_setup(qdev))
 		return -1;
 
 	/* Bring out PHY out of reset */
-	ql_write_common_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    (ISP_SERIAL_PORT_IF_WE |
-			     (ISP_SERIAL_PORT_IF_WE << 16)));
+	ql_write_common_reg(qdev, &regs->serialPortInterfaceReg,
+			    (ISP_SERIAL_PORT_IF_WE << 16) |
+			     ISP_SERIAL_PORT_IF_WE);
 
 	qdev->port_link_state = LS_DOWN;
 	netif_carrier_off(qdev->ndev);
 
 	/* V2 chip fix for ARS-39168. */
-	ql_write_common_reg(qdev, &port_regs->CommonRegs.serialPortInterfaceReg,
-			    (ISP_SERIAL_PORT_IF_SDE |
-			     (ISP_SERIAL_PORT_IF_SDE << 16)));
+	ql_write_common_reg(qdev, &regs->serialPortInterfaceReg,
+			    (ISP_SERIAL_PORT_IF_SDE << 16) |
+			     ISP_SERIAL_PORT_IF_SDE);
 
 	/* Request Queue Registers */
 	*((u32 *) (qdev->preq_consumer_index)) = 0;
-	atomic_set(&qdev->tx_count,NUM_REQ_Q_ENTRIES);
+	atomic_set(&qdev->tx_count, NUM_REQ_Q_ENTRIES);
 	qdev->req_producer_index = 0;
 
 	ql_write_page1_reg(qdev,
@@ -3277,13 +3661,9 @@ static int ql_adapter_initialize(struct 
 	qdev->lrg_buf_free_head = NULL;
 	qdev->lrg_buf_free_tail = NULL;
 
-	ql_write_common_reg(qdev,
-			    &port_regs->CommonRegs.
-			    rxSmallQProducerIndex,
+	ql_write_common_reg(qdev, &regs->rxSmallQProducerIndex,
 			    qdev->small_buf_q_producer_index);
-	ql_write_common_reg(qdev,
-			    &port_regs->CommonRegs.
-			    rxLargeQProducerIndex,
+	ql_write_common_reg(qdev, &regs->rxLargeQProducerIndex,
 			    qdev->lrg_buf_q_producer_index);
 
 	/*
@@ -3295,7 +3675,7 @@ static int ql_adapter_initialize(struct 
 	if ((value & PORT_STATUS_IC) == 0) {
 
 		/* Chip has not been configured yet, so let it rip. */
-		if(ql_init_misc_registers(qdev)) {
+		if (ql_init_misc_registers(qdev)) {
 			status = -1;
 			goto out;
 		}
@@ -3305,17 +3685,18 @@ static int ql_adapter_initialize(struct 
 
 		value = (0xFFFF << 16) | qdev->nvram_data.extHwConfig;
 
-		if(ql_sem_spinlock(qdev, QL_FLASH_SEM_MASK,
-				(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index)
-				 * 2) << 13)) {
-			status = -1;
+		status = ql_sem_spinlock(qdev, QL_FLASH_SEM_MASK,
+					 (QL_RESOURCE_BITS_BASE_CODE |
+					  (qdev->mac_index * 2) << 13));
+		if (status < 0)
 			goto out;
-		}
+
+#define INTERNAL_CHIP_SD_WE (INTERNAL_CHIP_SD | INTERNAL_CHIP_WE)
+
 		ql_write_page0_reg(qdev, &port_regs->ExternalHWConfig, value);
 		ql_write_page0_reg(qdev, &port_regs->InternalChipConfig,
-				   (((INTERNAL_CHIP_SD | INTERNAL_CHIP_WE) <<
-				     16) | (INTERNAL_CHIP_SD |
-					    INTERNAL_CHIP_WE)));
+				   (INTERNAL_CHIP_SD_WE << 16) |
+				    INTERNAL_CHIP_SD_WE);
 		ql_sem_unlock(qdev, QL_FLASH_SEM_MASK);
 	}
 
@@ -3328,12 +3709,11 @@ static int ql_adapter_initialize(struct 
 					   &port_regs->mac0MaxFrameLengthReg,
 					   qdev->max_frame_size);
 
-	if(ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
-			(QL_RESOURCE_BITS_BASE_CODE | (qdev->mac_index) *
-			 2) << 7)) {
-		status = -1;
+	status = ql_sem_spinlock(qdev, QL_PHY_GIO_SEM_MASK,
+				 (QL_RESOURCE_BITS_BASE_CODE |
+				  (qdev->mac_index * 2) << 13));
+	if (status < 0)
 		goto out;
-	}
 
 	PHY_Setup(qdev);
 	ql_init_scan_mode(qdev);
@@ -3343,42 +3723,40 @@ static int ql_adapter_initialize(struct 
 
 	/* Program lower 32 bits of the MAC address */
 	ql_write_page0_reg(qdev, &port_regs->macAddrIndirectPtrReg,
-			   (MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16));
+			   MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16);
 	ql_write_page0_reg(qdev, &port_regs->macAddrDataReg,
-			   ((qdev->ndev->dev_addr[2] << 24)
-			    | (qdev->ndev->dev_addr[3] << 16)
-			    | (qdev->ndev->dev_addr[4] << 8)
-			    | qdev->ndev->dev_addr[5]));
+			   (qdev->ndev->dev_addr[2] << 24) |
+			   (qdev->ndev->dev_addr[3] << 16) |
+			   (qdev->ndev->dev_addr[4] << 8) |
+			    qdev->ndev->dev_addr[5]);
 
 	/* Program top 16 bits of the MAC address */
 	ql_write_page0_reg(qdev, &port_regs->macAddrIndirectPtrReg,
-			   ((MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16) | 1));
+			   (MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16) | 1);
 	ql_write_page0_reg(qdev, &port_regs->macAddrDataReg,
-			   ((qdev->ndev->dev_addr[0] << 8)
-			    | qdev->ndev->dev_addr[1]));
+			   (qdev->ndev->dev_addr[0] << 8) |
+			    qdev->ndev->dev_addr[1]);
 
 	/* Enable Primary MAC */
 	ql_write_page0_reg(qdev, &port_regs->macAddrIndirectPtrReg,
-			   ((MAC_ADDR_INDIRECT_PTR_REG_PE << 16) |
-			    MAC_ADDR_INDIRECT_PTR_REG_PE));
+			   (MAC_ADDR_INDIRECT_PTR_REG_PE << 16) |
+			    MAC_ADDR_INDIRECT_PTR_REG_PE);
 
 	/* Clear Primary and Secondary IP addresses */
 	ql_write_page0_reg(qdev, &port_regs->ipAddrIndexReg,
-			   ((IP_ADDR_INDEX_REG_MASK << 16) |
-			    (qdev->mac_index << 2)));
+			   (IP_ADDR_INDEX_REG_MASK << 16) | (mac_index << 2));
 	ql_write_page0_reg(qdev, &port_regs->ipAddrDataReg, 0);
 
 	ql_write_page0_reg(qdev, &port_regs->ipAddrIndexReg,
-			   ((IP_ADDR_INDEX_REG_MASK << 16) |
-			    ((qdev->mac_index << 2) + 1)));
+			   (IP_ADDR_INDEX_REG_MASK << 16) |
+			   ((mac_index << 2) + 1));
 	ql_write_page0_reg(qdev, &port_regs->ipAddrDataReg, 0);
 
 	ql_sem_unlock(qdev, QL_PHY_GIO_SEM_MASK);
 
 	/* Indicate Configuration Complete */
-	ql_write_page0_reg(qdev,
-			   &port_regs->portControl,
-			   ((PORT_CONTROL_CC << 16) | PORT_CONTROL_CC));
+	ql_write_page0_reg(qdev, &port_regs->portControl,
+			   (PORT_CONTROL_CC << 16) | PORT_CONTROL_CC);
 
 	do {
 		value = ql_read_page0_reg(qdev, &port_regs->portStatus);
@@ -3395,6 +3773,7 @@ static int ql_adapter_initialize(struct 
 	}
 
 	/* Enable Ethernet Function */
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (qdev->device_id == QL3032_DEVICE_ID) {
 		value =
 		    (QL3032_PORT_CONTROL_EF | QL3032_PORT_CONTROL_KIE |
@@ -3410,6 +3789,20 @@ static int ql_adapter_initialize(struct 
 				   ((value << 16) | value));
 	}
 
+=======
+	if (qdev->device_id == QL3032_DEVICE_ID) {
+		value = QL3032_PORT_CONTROL_EF | QL3032_PORT_CONTROL_KIE |
+			QL3032_PORT_CONTROL_EIv6 | QL3032_PORT_CONTROL_EIv4;
+		ql_write_page0_reg(qdev, &port_regs->functionControl,
+				   (value << 16) | value);
+	} else {
+		value = PORT_CONTROL_EF | PORT_CONTROL_ET | PORT_CONTROL_EI |
+			PORT_CONTROL_HH;
+		ql_write_page0_reg(qdev, &port_regs->portControl,
+				   (value << 16) | value);
+	}
+
+>>>>>>> /drivers/net/qla3xxx.c
 
 out:
 	return status;
@@ -3420,7 +3813,7 @@ out:
  */
 static int ql_adapter_reset(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
+	u32 __iomem *ctl = &qdev->ioaddr->CommonRegs.ispControlStatus;
 	int status = 0;
 	u16 value;
 	int max_wait_time;
@@ -3431,12 +3824,9 @@ static int ql_adapter_reset(struct ql3_a
 	/*
 	 * Issue soft reset to chip.
 	 */
-	printk(KERN_DEBUG PFX
-	       "%s: Issue soft reset to chip.\n",
+	printk(KERN_DEBUG PFX "%s: Issue soft reset to chip.\n",
 	       qdev->ndev->name);
-	ql_write_common_reg(qdev,
-			    &port_regs->CommonRegs.ispControlStatus,
-			    ((ISP_CONTROL_SR << 16) | ISP_CONTROL_SR));
+	ql_write_common_reg(qdev, ctl, (ISP_CONTROL_SR << 16) | ISP_CONTROL_SR);
 
 	/* Wait 3 seconds for reset to complete. */
 	printk(KERN_DEBUG PFX
@@ -3446,9 +3836,7 @@ static int ql_adapter_reset(struct ql3_a
 	/* Wait until the firmware tells us the Soft Reset is done */
 	max_wait_time = 5;
 	do {
-		value =
-		    ql_read_common_reg(qdev,
-				       &port_regs->CommonRegs.ispControlStatus);
+		value = ql_read_common_reg(qdev, ctl);
 		if ((value & ISP_CONTROL_SR) == 0)
 			break;
 
@@ -3459,37 +3847,27 @@ static int ql_adapter_reset(struct ql3_a
 	 * Also, make sure that the Network Reset Interrupt bit has been
 	 * cleared after the soft reset has taken place.
 	 */
-	value =
-	    ql_read_common_reg(qdev, &port_regs->CommonRegs.ispControlStatus);
+	value = ql_read_common_reg(qdev, ctl);
 	if (value & ISP_CONTROL_RI) {
 		printk(KERN_DEBUG PFX
 		       "ql_adapter_reset: clearing RI after reset.\n");
-		ql_write_common_reg(qdev,
-				    &port_regs->CommonRegs.
-				    ispControlStatus,
-				    ((ISP_CONTROL_RI << 16) | ISP_CONTROL_RI));
+		ql_write_common_reg(qdev, ctl,
+				    (ISP_CONTROL_RI << 16) | ISP_CONTROL_RI);
 	}
 
 	if (max_wait_time == 0) {
 		/* Issue Force Soft Reset */
-		ql_write_common_reg(qdev,
-				    &port_regs->CommonRegs.
-				    ispControlStatus,
-				    ((ISP_CONTROL_FSR << 16) |
-				     ISP_CONTROL_FSR));
+		ql_write_common_reg(qdev, ctl,
+				    (ISP_CONTROL_FSR << 16) | ISP_CONTROL_FSR);
 		/*
 		 * Wait until the firmware tells us the Force Soft Reset is
 		 * done
 		 */
 		max_wait_time = 5;
 		do {
-			value =
-			    ql_read_common_reg(qdev,
-					       &port_regs->CommonRegs.
-					       ispControlStatus);
-			if ((value & ISP_CONTROL_FSR) == 0) {
+			value = ql_read_common_reg(qdev, ctl);
+			if ((value & ISP_CONTROL_FSR) == 0)
 				break;
-			}
 			ssleep(1);
 		} while ((--max_wait_time));
 	}
@@ -3503,13 +3881,13 @@ static int ql_adapter_reset(struct ql3_a
 
 static void ql_set_mac_info(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
+	struct ql3xxx_port_registers __iomem *port_regs = qdev->ioaddr;
+	u32 __iomem *ctl = &port_regs->CommonRegs.ispControlStatus;
 	u32 value, port_status;
 	u8 func_number;
 
 	/* Get the function number */
-	value =
-	    ql_read_common_reg_l(qdev, &port_regs->CommonRegs.ispControlStatus);
+	value = ql_read_common_reg_l(qdev, ctl);
 	func_number = (u8) ((value >> 4) & OPCODE_FUNC_ID_MASK);
 	port_status = ql_read_page0_reg(qdev, &port_regs->portStatus);
 	switch (value & ISP_CONTROL_FN_MASK) {
@@ -3521,9 +3899,9 @@ static void ql_set_mac_info(struct ql3_a
 		qdev->mb_bit_mask = FN0_MA_BITS_MASK;
 		qdev->PHYAddr = PORT0_PHY_ADDRESS;
 		if (port_status & PORT_STATUS_SM0)
-			set_bit(QL_LINK_OPTICAL,&qdev->flags);
+			set_bit(QL_LINK_OPTICAL, &qdev->flags);
 		else
-			clear_bit(QL_LINK_OPTICAL,&qdev->flags);
+			clear_bit(QL_LINK_OPTICAL, &qdev->flags);
 		break;
 
 	case ISP_CONTROL_FN1_NET:
@@ -3534,9 +3912,9 @@ static void ql_set_mac_info(struct ql3_a
 		qdev->mb_bit_mask = FN1_MA_BITS_MASK;
 		qdev->PHYAddr = PORT1_PHY_ADDRESS;
 		if (port_status & PORT_STATUS_SM1)
-			set_bit(QL_LINK_OPTICAL,&qdev->flags);
+			set_bit(QL_LINK_OPTICAL, &qdev->flags);
 		else
-			clear_bit(QL_LINK_OPTICAL,&qdev->flags);
+			clear_bit(QL_LINK_OPTICAL, &qdev->flags);
 		break;
 
 	case ISP_CONTROL_FN0_SCSI:
@@ -3544,7 +3922,7 @@ static void ql_set_mac_info(struct ql3_a
 	default:
 		printk(KERN_DEBUG PFX
 		       "%s: Invalid function number, ispControlStatus = 0x%x\n",
-		       qdev->ndev->name,value);
+		       qdev->ndev->name, value);
 		break;
 	}
 	qdev->numPorts = qdev->nvram_data.numPorts;
@@ -3552,10 +3930,11 @@ static void ql_set_mac_info(struct ql3_a
 
 static void ql_display_dev_info(struct net_device *ndev)
 {
-	struct ql3_adapter *qdev = (struct ql3_adapter *)netdev_priv(ndev);
+	struct ql3_adapter *qdev = netdev_priv(ndev);
 	struct pci_dev *pdev = qdev->pdev;
 
 	printk(KERN_INFO PFX
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	       "\n%s Adapter %d RevisionID %d found %s on PCI slot %d.\n",
 	       DRV_NAME, qdev->index, qdev->chip_rev_id,
 	       (qdev->device_id == QL3032_DEVICE_ID) ? "QLA3032" : "QLA3022",
@@ -3563,26 +3942,32 @@ static void ql_display_dev_info(struct n
 	printk(KERN_INFO PFX
 	       "%s Interface.\n",
 	       test_bit(QL_LINK_OPTICAL,&qdev->flags) ? "OPTICAL" : "COPPER");
+=======
+	       "\n%s: revision id %d. %s on PCI slot %d. %s interface.\n",
+	       ndev->name, qdev->chip_rev_id,
+	       (qdev->device_id == QL3032_DEVICE_ID) ? "QLA3032" : "QLA3022",
+	       qdev->pci_slot,
+	       test_bit(QL_LINK_OPTICAL, &qdev->flags) ? "OPTICAL" : "COPPER");
+>>>>>>> /drivers/net/qla3xxx.c
 
 	/*
 	 * Print PCI bus width/type.
 	 */
-	printk(KERN_INFO PFX
-	       "Bus interface is %s %s.\n",
-	       ((qdev->pci_width == 64) ? "64-bit" : "32-bit"),
-	       ((qdev->pci_x) ? "PCI-X" : "PCI"));
+	printk(KERN_INFO PFX "Bus interface is %s %s.\n",
+	       (qdev->pci_width == 64) ? "64-bit" : "32-bit",
+	       (qdev->pci_x) ? "PCI-X" : "PCI");
 
 	printk(KERN_INFO PFX
-	       "mem  IO base address adjusted = 0x%p\n",
-	       qdev->mem_map_registers);
+	       "mem  IO base address adjusted = 0x%p\n", qdev->ioaddr);
 	printk(KERN_INFO PFX "Interrupt number = %d\n", pdev->irq);
 
-	if (netif_msg_probe(qdev))
+	if (netif_msg_probe(qdev)) {
 		printk(KERN_INFO PFX
 		       "%s: MAC address %02x:%02x:%02x:%02x:%02x:%02x\n",
 		       ndev->name, ndev->dev_addr[0], ndev->dev_addr[1],
 		       ndev->dev_addr[2], ndev->dev_addr[3], ndev->dev_addr[4],
 		       ndev->dev_addr[5]);
+	}
 }
 
 static int ql_adapter_down(struct ql3_adapter *qdev, int do_reset)
@@ -3593,17 +3978,17 @@ static int ql_adapter_down(struct ql3_ad
 	netif_stop_queue(ndev);
 	netif_carrier_off(ndev);
 
-	clear_bit(QL_ADAPTER_UP,&qdev->flags);
-	clear_bit(QL_LINK_MASTER,&qdev->flags);
+	clear_bit(QL_ADAPTER_UP, &qdev->flags);
+	clear_bit(QL_LINK_MASTER, &qdev->flags);
 
 	ql_disable_interrupts(qdev);
 
 	free_irq(qdev->pdev->irq, ndev);
 
-	if (qdev->msi && test_bit(QL_MSI_ENABLED,&qdev->flags)) {
+	if (qdev->msi && test_bit(QL_MSI_ENABLED, &qdev->flags)) {
 		printk(KERN_INFO PFX
 		       "%s: calling pci_disable_msi().\n", qdev->ndev->name);
-		clear_bit(QL_MSI_ENABLED,&qdev->flags);
+		clear_bit(QL_MSI_ENABLED, &qdev->flags);
 		pci_disable_msi(qdev->pdev);
 	}
 
@@ -3612,25 +3997,25 @@ static int ql_adapter_down(struct ql3_ad
 	netif_poll_disable(ndev);
 
 	if (do_reset) {
-		int soft_reset;
-		unsigned long hw_flags;
+		unsigned long flags;
 
-		spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+		/* FIXME: ssleep with spinlock held in ql_wait_for_drvr_lock */
+		spin_lock_irqsave(&qdev->hw_lock, flags);
 		if (ql_wait_for_drvr_lock(qdev)) {
-			if ((soft_reset = ql_adapter_reset(qdev))) {
+			if (ql_adapter_reset(qdev)) {
 				printk(KERN_ERR PFX
-				       "%s: ql_adapter_reset(%d) FAILED!\n",
-				       ndev->name, qdev->index);
+				       "%s: ql_adapter_reset() FAILED!\n",
+				       ndev->name);
 			}
 			printk(KERN_ERR PFX
-				"%s: Releaseing driver lock via chip reset.\n",ndev->name);
+				"%s: Releaseing driver lock via chip reset.\n", ndev->name);
 		} else {
 			printk(KERN_ERR PFX
 			       "%s: Could not acquire driver lock to do "
 			       "reset!\n", ndev->name);
 			retval = -1;
 		}
-		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+		spin_unlock_irqrestore(&qdev->hw_lock, flags);
 	}
 	ql_free_mem_resources(qdev);
 	return retval;
@@ -3640,8 +4025,13 @@ static int ql_adapter_up(struct ql3_adap
 {
 	struct net_device *ndev = qdev->ndev;
 	int err;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	unsigned long irq_flags = IRQF_SAMPLE_RANDOM | IRQF_SHARED;
 	unsigned long hw_flags;
+=======
+	unsigned long irq_flags = SA_SAMPLE_RANDOM | SA_SHIRQ;
+	unsigned long flags;
+>>>>>>> /drivers/net/qla3xxx.c
 
 	if (ql_alloc_mem_resources(qdev)) {
 		printk(KERN_ERR PFX
@@ -3658,42 +4048,49 @@ static int ql_adapter_up(struct ql3_adap
 			qdev->msi = 0;
 		} else {
 			printk(KERN_INFO PFX "%s: MSI Enabled...\n", qdev->ndev->name);
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 			set_bit(QL_MSI_ENABLED,&qdev->flags);
 			irq_flags &= ~IRQF_SHARED;
+=======
+			set_bit(QL_MSI_ENABLED, &qdev->flags);
+			irq_flags &= ~SA_SHIRQ;
+>>>>>>> /drivers/net/qla3xxx.c
 		}
 	}
 
-	if ((err = request_irq(qdev->pdev->irq,
-			       ql3xxx_isr,
-			       irq_flags, ndev->name, ndev))) {
+	err = request_irq(qdev->pdev->irq, ql3xxx_isr, irq_flags, ndev->name,
+			  ndev);
+	if (err < 0) {
 		printk(KERN_ERR PFX
 		       "%s: Failed to reserve interrupt %d already in use.\n",
 		       ndev->name, qdev->pdev->irq);
 		goto err_irq;
 	}
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	/* FIXME: ssleep with spinlock held in ql_wait_for_drvr_lock */
+	spin_lock_irqsave(&qdev->hw_lock, flags);
 
-	if ((err = ql_wait_for_drvr_lock(qdev))) {
-		if ((err = ql_adapter_initialize(qdev))) {
+	err = ql_wait_for_drvr_lock(qdev);
+	if (err) {
+		err = ql_adapter_initialize(qdev);
+		if (err < 0) {
 			printk(KERN_ERR PFX
 			       "%s: Unable to initialize adapter.\n",
 			       ndev->name);
 			goto err_init;
 		}
-		printk(KERN_ERR PFX
-				"%s: Releaseing driver lock.\n",ndev->name);
+		printk(KERN_ERR PFX "%s: Releaseing driver lock.\n",
+		       ndev->name);
 		ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
 	} else {
-		printk(KERN_ERR PFX
-		       "%s: Could not aquire driver lock.\n",
+		printk(KERN_ERR PFX "%s: Could not aquire driver lock.\n",
 		       ndev->name);
 		goto err_lock;
 	}
 
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 
-	set_bit(QL_ADAPTER_UP,&qdev->flags);
+	set_bit(QL_ADAPTER_UP, &qdev->flags);
 
 	mod_timer(&qdev->adapter_timer, jiffies + HZ * 1);
 
@@ -3707,11 +4104,10 @@ err_lock:
 	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 	free_irq(qdev->pdev->irq, ndev);
 err_irq:
-	if (qdev->msi && test_bit(QL_MSI_ENABLED,&qdev->flags)) {
-		printk(KERN_INFO PFX
-		       "%s: calling pci_disable_msi().\n",
+	if (qdev->msi && test_bit(QL_MSI_ENABLED, &qdev->flags)) {
+		printk(KERN_INFO PFX "%s: calling pci_disable_msi().\n",
 		       qdev->ndev->name);
-		clear_bit(QL_MSI_ENABLED,&qdev->flags);
+		clear_bit(QL_MSI_ENABLED, &qdev->flags);
 		pci_disable_msi(qdev->pdev);
 	}
 	return err;
@@ -3719,10 +4115,9 @@ err_irq:
 
 static int ql_cycle_adapter(struct ql3_adapter *qdev, int reset)
 {
-	if( ql_adapter_down(qdev,reset) || ql_adapter_up(qdev)) {
-		printk(KERN_ERR PFX
-				"%s: Driver up/down cycle failed, "
-				"closing device\n",qdev->ndev->name);
+	if (ql_adapter_down(qdev, reset) || ql_adapter_up(qdev)) {
+		printk(KERN_ERR PFX "%s: Driver up/down cycle failed, "
+		       "closing device\n", qdev->ndev->name);
 		dev_close(qdev->ndev);
 		return -1;
 	}
@@ -3737,25 +4132,52 @@ static int ql3xxx_close(struct net_devic
 	 * Wait for device to recover from a reset.
 	 * (Rarely happens, but possible.)
 	 */
-	while (!test_bit(QL_ADAPTER_UP,&qdev->flags))
+	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
 		msleep(50);
 
-	ql_adapter_down(qdev,QL_DO_RESET);
+	ql_adapter_down(qdev, QL_DO_RESET);
 	return 0;
 }
 
 static int ql3xxx_open(struct net_device *ndev)
 {
 	struct ql3_adapter *qdev = netdev_priv(ndev);
-	return (ql_adapter_up(qdev));
+
+	return ql_adapter_up(qdev);
 }
 
 static struct net_device_stats *ql3xxx_get_stats(struct net_device *dev)
 {
-	struct ql3_adapter *qdev = (struct ql3_adapter *)dev->priv;
+	struct ql3_adapter *qdev = netdev_priv(dev);
+
 	return &qdev->stats;
 }
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
+=======
+static int ql3xxx_change_mtu(struct net_device *ndev, int new_mtu)
+{
+	struct ql3_adapter *qdev = netdev_priv(ndev);
+
+	printk(KERN_ERR PFX "%s:  new mtu size = %d.\n", ndev->name, new_mtu);
+	if (new_mtu != NORMAL_MTU_SIZE && new_mtu != JUMBO_MTU_SIZE) {
+		printk(KERN_ERR PFX
+		       "%s: mtu size of %d is not valid.  Use exactly %d or "
+		       "%d.\n", ndev->name, new_mtu, NORMAL_MTU_SIZE,
+		       JUMBO_MTU_SIZE);
+		return -EINVAL;
+	}
+
+	if (!netif_running(ndev)) {
+		ndev->mtu = new_mtu;
+		return 0;
+	}
+
+	ndev->mtu = new_mtu;
+	return ql_cycle_adapter(qdev, QL_DO_RESET);
+}
+
+>>>>>>> /drivers/net/qla3xxx.c
 static void ql3xxx_set_multicast_list(struct net_device *ndev)
 {
 	/*
@@ -3766,11 +4188,11 @@ static void ql3xxx_set_multicast_list(st
 
 static int ql3xxx_set_mac_address(struct net_device *ndev, void *p)
 {
-	struct ql3_adapter *qdev = (struct ql3_adapter *)netdev_priv(ndev);
-	struct ql3xxx_port_registers __iomem *port_regs =
-	    		qdev->mem_map_registers;
+	struct ql3_adapter *qdev = netdev_priv(ndev);
+	u32 __iomem *indirect = &qdev->ioaddr->macAddrIndirectPtrReg;
+	u32 __iomem *mac_addr = &qdev->ioaddr->macAddrDataReg;
 	struct sockaddr *addr = p;
-	unsigned long hw_flags;
+	unsigned long flags;
 
 	if (netif_running(ndev))
 		return -EBUSY;
@@ -3780,28 +4202,32 @@ static int ql3xxx_set_mac_address(struct
 
 	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);
 
-	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
+	spin_lock_irqsave(&qdev->hw_lock, flags);
+
 	/* Program lower 32 bits of the MAC address */
-	ql_write_page0_reg(qdev, &port_regs->macAddrIndirectPtrReg,
-			   (MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16));
-	ql_write_page0_reg(qdev, &port_regs->macAddrDataReg,
-			   ((ndev->dev_addr[2] << 24) | (ndev->
-							 dev_addr[3] << 16) |
-			    (ndev->dev_addr[4] << 8) | ndev->dev_addr[5]));
+	ql_write_page0_reg(qdev, indirect,
+			   MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16);
+	ql_write_page0_reg(qdev, mac_addr,
+			   (ndev->dev_addr[2] << 24) |
+			   (ndev->dev_addr[3] << 16) |
+			   (ndev->dev_addr[4] <<  8) |
+			    ndev->dev_addr[5]);
 
 	/* Program top 16 bits of the MAC address */
-	ql_write_page0_reg(qdev, &port_regs->macAddrIndirectPtrReg,
-			   ((MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16) | 1));
-	ql_write_page0_reg(qdev, &port_regs->macAddrDataReg,
-			   ((ndev->dev_addr[0] << 8) | ndev->dev_addr[1]));
-	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+	ql_write_page0_reg(qdev, indirect,
+			   (MAC_ADDR_INDIRECT_PTR_REG_RP_MASK << 16) | 1);
+	ql_write_page0_reg(qdev, mac_addr,
+			   (ndev->dev_addr[0] << 8) |
+			    ndev->dev_addr[1]);
+
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 
 	return 0;
 }
 
 static void ql3xxx_tx_timeout(struct net_device *ndev)
 {
-	struct ql3_adapter *qdev = (struct ql3_adapter *)netdev_priv(ndev);
+	struct ql3_adapter *qdev = netdev_priv(ndev);
 
 	printk(KERN_ERR PFX "%s: Resetting...\n", ndev->name);
 	/*
@@ -3819,16 +4245,44 @@ static void ql_reset_work(struct work_st
 {
 	struct ql3_adapter *qdev =
 		container_of(work, struct ql3_adapter, reset_work.work);
-	struct net_device *ndev = qdev->ndev;
+	u32 __iomem *reg = &qdev->ioaddr->CommonRegs.ispControlStatus;
+	u32 cmd = (ISP_CONTROL_RI << 16) | ISP_CONTROL_RI;
+	char *name = qdev->ndev->name;
+	unsigned long flags;
+	unsigned int i;
 	u32 value;
-	struct ql_tx_buf_cb *tx_cb;
-	int max_wait_time, i;
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
-	unsigned long hw_flags;
 
-	if (test_bit((QL_RESET_PER_SCSI | QL_RESET_START),&qdev->flags)) {
-		clear_bit(QL_LINK_MASTER,&qdev->flags);
+	if (!test_bit(QL_RESET_PER_SCSI | QL_RESET_START, &qdev->flags))
+		return;
+
+	clear_bit(QL_LINK_MASTER, &qdev->flags);
+
+	/*
+	 * Loop through the active list and return the skb.
+	 */
+	for (i = 0; i < NUM_REQ_Q_ENTRIES; i++) {
+		struct ql_tx_buf_cb *tx_cb = &qdev->tx_buf[i];
+		unsigned int j;
+
+		if (!tx_cb->skb)
+			continue;
+
+		printk(KERN_DEBUG PFX "%s: Freeing lost SKB.\n", name);
+
+		for (j = 0; !j || (j < tx_cb->seg_count); j++) {
+			pci_unmap_page(qdev->pdev,
+				       pci_unmap_addr(&tx_cb->map[j], mapaddr),
+				       pci_unmap_len(&tx_cb->map[j], maplen),
+				       PCI_DMA_TODEVICE);
+		}
+
+		dev_kfree_skb(tx_cb->skb);
+		tx_cb->skb = NULL;
+	}
+
+	printk(KERN_ERR PFX "%s: Clearing NRI after reset.\n", name);
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 		/*
 		 * Loop through the active list and return the skb.
 		 */
@@ -3852,68 +4306,52 @@ static void ql_reset_work(struct work_st
 				dev_kfree_skb(tx_cb->skb);
 				tx_cb->skb = NULL;
 			}
+=======
+	spin_lock_irqsave(&qdev->hw_lock, flags);
+
+	ql_write_common_reg(qdev, reg, cmd);
+	/*
+	 * Wait the for Soft Reset to Complete.
+	 */
+	for (i = 0; i < 10; i++) {
+		value = ql_read_common_reg(qdev, reg);
+		if (!(value & ISP_CONTROL_SR)) {
+			printk(KERN_DEBUG PFX "%s: reset completed.\n", name);
+			break;
+>>>>>>> /drivers/net/qla3xxx.c
 		}
 
-		printk(KERN_ERR PFX
-		       "%s: Clearing NRI after reset.\n", qdev->ndev->name);
-		spin_lock_irqsave(&qdev->hw_lock, hw_flags);
-		ql_write_common_reg(qdev,
-				    &port_regs->CommonRegs.
-				    ispControlStatus,
-				    ((ISP_CONTROL_RI << 16) | ISP_CONTROL_RI));
-		/*
-		 * Wait the for Soft Reset to Complete.
-		 */
-		max_wait_time = 10;
-		do {
-			value = ql_read_common_reg(qdev,
-						   &port_regs->CommonRegs.
+		if (value & ISP_CONTROL_RI) {
+			printk(KERN_DEBUG PFX
+			       "%s: clearing NRI after reset.\n", name);
+			ql_write_common_reg(qdev, reg, cmd);
+		}
 
-						   ispControlStatus);
-			if ((value & ISP_CONTROL_SR) == 0) {
-				printk(KERN_DEBUG PFX
-				       "%s: reset completed.\n",
-				       qdev->ndev->name);
-				break;
-			}
+		// FIXME: sleeping with spinlock held, yeah !
+		ssleep(1);
+	}
 
-			if (value & ISP_CONTROL_RI) {
-				printk(KERN_DEBUG PFX
-				       "%s: clearing NRI after reset.\n",
-				       qdev->ndev->name);
-				ql_write_common_reg(qdev,
-						    &port_regs->
-						    CommonRegs.
-						    ispControlStatus,
-						    ((ISP_CONTROL_RI <<
-						      16) | ISP_CONTROL_RI));
-			}
+	spin_unlock_irqrestore(&qdev->hw_lock, flags);
 
-			ssleep(1);
-		} while (--max_wait_time);
-		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
+	if (value & ISP_CONTROL_SR) {
+		/*
+		 * Set the reset flags and clear the board again.
+		 * Nothing else to do...
+		 */
+		printk(KERN_ERR PFX
+		       "%s: Timed out waiting for reset to complete.\n", name);
+		printk(KERN_ERR PFX "%s: Do a reset.\n", name);
 
-		if (value & ISP_CONTROL_SR) {
+		clear_bit(QL_RESET_PER_SCSI, &qdev->flags);
+		clear_bit(QL_RESET_START, &qdev->flags);
 
-			/*
-			 * Set the reset flags and clear the board again.
-			 * Nothing else to do...
-			 */
-			printk(KERN_ERR PFX
-			       "%s: Timed out waiting for reset to "
-			       "complete.\n", ndev->name);
-			printk(KERN_ERR PFX
-			       "%s: Do a reset.\n", ndev->name);
-			clear_bit(QL_RESET_PER_SCSI,&qdev->flags);
-			clear_bit(QL_RESET_START,&qdev->flags);
-			ql_cycle_adapter(qdev,QL_DO_RESET);
-			return;
-		}
+		ql_cycle_adapter(qdev, QL_DO_RESET);
+	} else {
+		clear_bit(QL_RESET_ACTIVE, &qdev->flags);
+		clear_bit(QL_RESET_PER_SCSI, &qdev->flags);
+		clear_bit(QL_RESET_START, &qdev->flags);
 
-		clear_bit(QL_RESET_ACTIVE,&qdev->flags);
-		clear_bit(QL_RESET_PER_SCSI,&qdev->flags);
-		clear_bit(QL_RESET_START,&qdev->flags);
-		ql_cycle_adapter(qdev,QL_NO_RESET);
+		ql_cycle_adapter(qdev, QL_NO_RESET);
 	}
 }
 
@@ -3927,12 +4365,11 @@ static void ql_tx_timeout_work(struct wo
 
 static void ql_get_board_info(struct ql3_adapter *qdev)
 {
-	struct ql3xxx_port_registers __iomem *port_regs = qdev->mem_map_registers;
 	u32 value;
 
-	value = ql_read_page0_reg_l(qdev, &port_regs->portStatus);
+	value = ql_read_page0_reg_l(qdev, &qdev->ioaddr->portStatus);
 
-	qdev->chip_rev_id = ((value & PORT_STATUS_REV_ID_MASK) >> 12);
+	qdev->chip_rev_id = (value & PORT_STATUS_REV_ID_MASK) >> 12;
 	if (value & PORT_STATUS_64)
 		qdev->pci_width = 64;
 	else
@@ -3948,7 +4385,7 @@ static void ql3xxx_timer(unsigned long p
 {
 	struct ql3_adapter *qdev = (struct ql3_adapter *)ptr;
 
-	if (test_bit(QL_RESET_ACTIVE,&qdev->flags)) {
+	if (test_bit(QL_RESET_ACTIVE, &qdev->flags)) {
 		printk(KERN_DEBUG PFX
 		       "%s: Reset in progress.\n",
 		       qdev->ndev->name);
@@ -3965,23 +4402,23 @@ end:
 static int __devinit ql3xxx_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *pci_entry)
 {
-	struct net_device *ndev = NULL;
-	struct ql3_adapter *qdev = NULL;
-	static int cards_found = 0;
+	static int ql_version_printed = 0;
+	struct ql3_adapter *qdev;
+	struct net_device *ndev;
 	int pci_using_dac, err;
 
 	err = pci_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR PFX "%s cannot enable PCI device\n",
 		       pci_name(pdev));
-		goto err_out;
+		goto out;
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
-	if (err) {
+	if (err < 0) {
 		printk(KERN_ERR PFX "%s cannot obtain PCI resources\n",
 		       pci_name(pdev));
-		goto err_out_disable_pdev;
+		goto err_out_disable_pdev_0;
 	}
 
 	pci_set_master(pdev);
@@ -3989,24 +4426,31 @@ static int __devinit ql3xxx_probe(struct
 	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
 		pci_using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	} else if (!(err = pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
+	} else {
 		pci_using_dac = 0;
-		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (!err)
+			err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 	}
 
-	if (err) {
+	if (err < 0) {
 		printk(KERN_ERR PFX "%s no usable DMA configuration\n",
 		       pci_name(pdev));
-		goto err_out_free_regions;
+		goto err_out_free_regions_1;
 	}
 
 	ndev = alloc_etherdev(sizeof(struct ql3_adapter));
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (!ndev) {
 		printk(KERN_ERR PFX "%s could not alloc etherdev\n",
 		       pci_name(pdev));
 		err = -ENOMEM;
 		goto err_out_free_regions;
 	}
+=======
+	if (!ndev)
+		goto err_out_free_regions_1;
+>>>>>>> /drivers/net/qla3xxx.c
 
 	SET_MODULE_OWNER(ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
@@ -4014,7 +4458,6 @@ static int __devinit ql3xxx_probe(struct
 	pci_set_drvdata(pdev, ndev);
 
 	qdev = netdev_priv(ndev);
-	qdev->index = cards_found;
 	qdev->ndev = ndev;
 	qdev->pdev = pdev;
 	qdev->device_id = pci_entry->device;
@@ -4024,6 +4467,7 @@ static int __devinit ql3xxx_probe(struct
 
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
 
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (pci_using_dac)
 		ndev->features |= NETIF_F_HIGHDMA;
 	if (qdev->device_id == QL3032_DEVICE_ID)
@@ -4033,10 +4477,24 @@ static int __devinit ql3xxx_probe(struct
 	    ioremap_nocache(pci_resource_start(pdev, 1),
 			    pci_resource_len(qdev->pdev, 1));
 	if (!qdev->mem_map_registers) {
+=======
+	if (pci_using_dac)
+		ndev->features |= NETIF_F_HIGHDMA;
+	if (qdev->device_id == QL3032_DEVICE_ID)
+		ndev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+
+	qdev->ioaddr = ioremap_nocache(pci_resource_start(pdev, 1),
+				       pci_resource_len(pdev, 1));
+	if (!qdev->ioaddr) {
+>>>>>>> /drivers/net/qla3xxx.c
 		printk(KERN_ERR PFX "%s: cannot map device registers\n",
 		       pci_name(pdev));
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 		err = -EIO;
 		goto err_out_free_ndev;
+=======
+		goto err_out_free_ndev_2;
+>>>>>>> /drivers/net/qla3xxx.c
 	}
 
 	spin_lock_init(&qdev->adapter_lock);
@@ -4044,14 +4502,18 @@ static int __devinit ql3xxx_probe(struct
 
 	/* Set driver entry points */
 	ndev->open = ql3xxx_open;
-	ndev->hard_start_xmit = ql3xxx_send;
 	ndev->stop = ql3xxx_close;
 	ndev->get_stats = ql3xxx_get_stats;
-	ndev->set_multicast_list = ql3xxx_set_multicast_list;
-	SET_ETHTOOL_OPS(ndev, &ql3xxx_ethtool_ops);
-	ndev->set_mac_address = ql3xxx_set_mac_address;
+<<<<<<< HEAD/drivers/net/qla3xxx.c
+=======
+	ndev->change_mtu = ql3xxx_change_mtu;
 	ndev->tx_timeout = ql3xxx_tx_timeout;
 	ndev->watchdog_timeo = 5 * HZ;
+	ndev->hard_start_xmit = ql3xxx_send;
+	ndev->set_mac_address = ql3xxx_set_mac_address;
+>>>>>>> /drivers/net/qla3xxx.c
+	ndev->set_multicast_list = ql3xxx_set_multicast_list;
+	SET_ETHTOOL_OPS(ndev, &ql3xxx_ethtool_ops);
 
 	ndev->poll = &ql_poll;
 	ndev->weight = 64;
@@ -4059,17 +4521,25 @@ static int __devinit ql3xxx_probe(struct
 	ndev->irq = pdev->irq;
 
 	/* make sure the EEPROM is good */
-	if (ql_get_nvram_params(qdev)) {
+	err = ql_get_nvram_params(qdev);
+	if (err < 0) {
 		printk(KERN_ALERT PFX
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 		       "ql3xxx_probe: Adapter #%d, Invalid NVRAM parameters.\n",
 		       qdev->index);
 		err = -EIO;
 		goto err_out_iounmap;
+=======
+		       "ql3xxx_probe: %s, invalid NVRAM parameters.\n",
+		       pci_name(pdev));
+		goto err_out_iounmap_3;
+>>>>>>> /drivers/net/qla3xxx.c
 	}
 
 	ql_set_mac_info(qdev);
 
 	/* Validate and set parameters */
+<<<<<<< HEAD/drivers/net/qla3xxx.c
 	if (qdev->mac_index) {
 		ndev->mtu = qdev->nvram_data.macCfg_port1.etherMtu_mac ;
 		memcpy(ndev->dev_addr, &qdev->nvram_data.funcCfg_fn2.macAddress,
@@ -4079,6 +4549,11 @@ static int __devinit ql3xxx_probe(struct
 		memcpy(ndev->dev_addr, &qdev->nvram_data.funcCfg_fn0.macAddress,
 		       ETH_ALEN);
 	}
+=======
+	memcpy(ndev->dev_addr, qdev->mac_index ?
+	       &qdev->nvram_data.funcCfg_fn2.macAddress :
+	       &qdev->nvram_data.funcCfg_fn0.macAddress, ETH_ALEN);
+>>>>>>> /drivers/net/qla3xxx.c
 	memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
 
 	ndev->tx_queue_len = NUM_REQ_Q_ENTRIES;
@@ -4093,15 +4568,14 @@ static int __devinit ql3xxx_probe(struct
 	 * Set the Maximum Memory Read Byte Count value. We do this to handle
 	 * jumbo frames.
 	 */
-	if (qdev->pci_x) {
+	if (qdev->pci_x)
 		pci_write_config_word(pdev, (int)0x4e, (u16) 0x0036);
-	}
 
 	err = register_netdev(ndev);
-	if (err) {
+	if (err < 0) {
 		printk(KERN_ERR PFX "%s: cannot register net device\n",
 		       pci_name(pdev));
-		goto err_out_iounmap;
+		goto err_out_iounmap_3;
 	}
 
 	/* we're going to reset, so assume we have no link for now */
@@ -4118,27 +4592,25 @@ static int __devinit ql3xxx_probe(struct
 	qdev->adapter_timer.expires = jiffies + HZ * 2;	/* two second delay */
 	qdev->adapter_timer.data = (unsigned long)qdev;
 
-	if(!cards_found) {
+	if (!ql_version_printed) {
 		printk(KERN_ALERT PFX "%s\n", DRV_STRING);
 		printk(KERN_ALERT PFX "Driver name: %s, Version: %s.\n",
-	    	   DRV_NAME, DRV_VERSION);
+		       DRV_NAME, DRV_VERSION);
 	}
 	ql_display_dev_info(ndev);
+out:
+	return err;
 
-	cards_found++;
-	return 0;
-
-err_out_iounmap:
-	iounmap(qdev->mem_map_registers);
-err_out_free_ndev:
+err_out_iounmap_3:
+	iounmap(qdev->ioaddr);
+err_out_free_ndev_2:
+	pci_set_drvdata(pdev, NULL);
 	free_netdev(ndev);
-err_out_free_regions:
+err_out_free_regions_1:
 	pci_release_regions(pdev);
-err_out_disable_pdev:
+err_out_disable_pdev_0:
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
-err_out:
-	return err;
+	goto out;
 }
 
 static void __devexit ql3xxx_remove(struct pci_dev *pdev)
@@ -4147,7 +4619,6 @@ static void __devexit ql3xxx_remove(stru
 	struct ql3_adapter *qdev = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	qdev = netdev_priv(ndev);
 
 	ql_disable_interrupts(qdev);
 
@@ -4158,18 +4629,17 @@ static void __devexit ql3xxx_remove(stru
 		qdev->workqueue = NULL;
 	}
 
-	iounmap(qdev->mem_map_registers);
+	iounmap(qdev->ioaddr);
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_netdev(ndev);
 }
 
 static struct pci_driver ql3xxx_driver = {
-
-	.name = DRV_NAME,
-	.id_table = ql3xxx_pci_tbl,
-	.probe = ql3xxx_probe,
-	.remove = __devexit_p(ql3xxx_remove),
+	.name		= DRV_NAME,
+	.id_table	= ql3xxx_pci_tbl,
+	.probe		= ql3xxx_probe,
+	.remove		= __devexit_p(ql3xxx_remove),
 };
 
 static int __init ql3xxx_init_module(void)
diff --git a/drivers/net/qla3xxx.h b/drivers/net/qla3xxx.h
index 4a832c4..ec7fa72 100755
--- a/drivers/net/qla3xxx.h
+++ b/drivers/net/qla3xxx.h
@@ -1104,6 +1104,7 @@ struct ql_rcv_buf_cb {
 	int index;
 };
 
+<<<<<<< HEAD/drivers/net/qla3xxx.h
 /*
  * Original IOCB has 3 sg entries:
  * first points to skb-data area
@@ -1132,6 +1133,37 @@ struct map_list {
 	 DECLARE_PCI_UNMAP_LEN(maplen);
 };
 
+=======
+/*
+ * Original IOCB has 3 sg entries:
+ * first points to skb-data area
+ * second points to first frag
+ * third points to next oal.
+ * OAL has 5 entries:
+ * 1 thru 4 point to frags
+ * fifth points to next oal.
+ */ 
+#define MAX_OAL_CNT ((MAX_SKB_FRAGS-1)/4 + 1)
+
+struct oal_entry {
+	u32 dma_lo;
+	u32 dma_hi;
+	u32 len;
+#define OAL_LAST_ENTRY   0x80000000	/* Last valid buffer in list. */
+#define OAL_CONT_ENTRY   0x40000000	/* points to an OAL. (continuation) */
+	u32 reserved;
+};
+
+struct oal {
+	struct oal_entry oal_entry[5];
+};
+
+struct map_list {
+	 DECLARE_PCI_UNMAP_ADDR(mapaddr);
+	 DECLARE_PCI_UNMAP_LEN(maplen);
+};
+
+>>>>>>> /drivers/net/qla3xxx.h
 struct ql_tx_buf_cb {
 	struct sk_buff *skb;
 	struct ob_mac_iocb_req *queue_entry ;
@@ -1181,15 +1213,13 @@ struct ql3_adapter {
 	u8 pci_width;
 	u8 pci_x;
 	u32 msi;
-	int index;
 	struct timer_list adapter_timer;	/* timer used for various functions */
 
 	spinlock_t adapter_lock;
 	spinlock_t hw_lock;
 
 	/* PCI Bus Relative Register Addresses */
-	u8 __iomem *mmap_virt_base;	/* stores return value from ioremap() */
-	struct ql3xxx_port_registers __iomem *mem_map_registers;
+	struct ql3xxx_port_registers __iomem *ioaddr;
 	u32 current_page;	/* tracks current register page */
 
 	u32 msg_enable;
@@ -1286,8 +1316,12 @@ struct ql3_adapter {
 	struct delayed_work reset_work;
 	struct delayed_work tx_timeout_work;
 	u32 max_frame_size;
+<<<<<<< HEAD/drivers/net/qla3xxx.h
 	u32 device_id;
 	u16 phyType;
+=======
+	u32 device_id;
+>>>>>>> /drivers/net/qla3xxx.h
 };
 
 #endif				/* _QLA3XXX_H_ */
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index fc82a9a..97190ca 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -7334,7 +7334,11 @@ #endif
 		dev->features |= NETIF_F_HIGHDMA;
 	dev->features |= NETIF_F_TSO;
 	dev->features |= NETIF_F_TSO6;
+<<<<<<< HEAD/drivers/net/s2io.c
 	if ((sp->device_type & XFRAME_II_DEVICE) && (ufo))  {
+=======
+	if (sp->device_type & XFRAME_II_DEVICE) {
+>>>>>>> /drivers/net/s2io.c
 		dev->features |= NETIF_F_UFO;
 		dev->features |= NETIF_F_HW_CSUM;
 	}
* Unmerged path drivers/net/sc92031.c
diff --git a/drivers/net/skfp/drvfbi.c b/drivers/net/skfp/drvfbi.c
index c77cc14..8f3988e 100644
--- a/drivers/net/skfp/drvfbi.c
+++ b/drivers/net/skfp/drvfbi.c
@@ -287,6 +287,33 @@ void read_address(struct s_smc *smc, u_c
 	char PmdType ;
 	int	i ;
 
+<<<<<<< HEAD/drivers/net/skfp/drvfbi.c
+=======
+#if	(defined(ISA) || defined(MCA))
+	for (i = 0; i < 4 ;i++) {	/* read mac address from board */
+		smc->hw.fddi_phys_addr.a[i] =
+			bitrev8(inpw(PR_A(i+SA_MAC)));
+	}
+	for (i = 4; i < 6; i++) {
+		smc->hw.fddi_phys_addr.a[i] =
+			bitrev8(inpw(PR_A(i+SA_MAC+PRA_OFF)));
+	}
+#endif
+#ifdef	EISA
+	/*
+	 * Note: We get trouble on an Alpha machine if we make a inpw()
+	 * instead of inp()
+	 */
+	for (i = 0; i < 4 ;i++) {	/* read mac address from board */
+		smc->hw.fddi_phys_addr.a[i] =
+			bitrev8(inp(PR_A(i+SA_MAC)));
+	}
+	for (i = 4; i < 6; i++) {
+		smc->hw.fddi_phys_addr.a[i] =
+			bitrev8(inp(PR_A(i+SA_MAC+PRA_OFF)));
+	}
+#endif
+>>>>>>> /drivers/net/skfp/drvfbi.c
 #ifdef	PCI
 	for (i = 0; i < 6; i++) {	/* read mac address from board */
 		smc->hw.fddi_phys_addr.a[i] =
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index e7a2ead..5c47745 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -219,19 +219,48 @@ static void sky2_power_on(struct sky2_hw
 	else
 		sky2_write8(hw, B2_Y2_CLK_GATE, 0);
 
+<<<<<<< HEAD/drivers/net/sky2.c
 	if (hw->chip_id == CHIP_ID_YUKON_EC_U || hw->chip_id == CHIP_ID_YUKON_EX) {
 		u32 reg;
+=======
+	if (hw->chip_id == CHIP_ID_YUKON_EC_U) {
+		u32 reg1;
+>>>>>>> /drivers/net/sky2.c
 
+<<<<<<< HEAD/drivers/net/sky2.c
 		reg = sky2_pci_read32(hw, PCI_DEV_REG4);
 		/* set all bits to 0 except bits 15..12 and 8 */
 		reg &= P_ASPM_CONTROL_MSK;
 		sky2_pci_write32(hw, PCI_DEV_REG4, reg);
+=======
+		sky2_pci_write32(hw, PCI_DEV_REG3, 0);
+		reg1 = sky2_pci_read32(hw, PCI_DEV_REG4);
+		reg1 &= P_ASPM_CONTROL_MSK;
+		sky2_pci_write32(hw, PCI_DEV_REG4, reg1);
+		sky2_pci_write32(hw, PCI_DEV_REG5, 0);
+	}
+}
+>>>>>>> /drivers/net/sky2.c
 
+<<<<<<< HEAD/drivers/net/sky2.c
 		reg = sky2_pci_read32(hw, PCI_DEV_REG5);
 		/* set all bits to 0 except bits 28 & 27 */
 		reg &= P_CTL_TIM_VMAIN_AV_MSK;
 		sky2_pci_write32(hw, PCI_DEV_REG5, reg);
+=======
+static void sky2_power_aux(struct sky2_hw *hw)
+{
+	if (hw->chip_id == CHIP_ID_YUKON_XL && hw->chip_rev > 1)
+		sky2_write8(hw, B2_Y2_CLK_GATE, 0);
+	else
+		/* enable bits are inverted */
+		sky2_write8(hw, B2_Y2_CLK_GATE,
+			    Y2_PCI_CLK_LNK1_DIS | Y2_COR_CLK_LNK1_DIS |
+			    Y2_CLK_GAT_LNK1_DIS | Y2_PCI_CLK_LNK2_DIS |
+			    Y2_COR_CLK_LNK2_DIS | Y2_CLK_GAT_LNK2_DIS);
+>>>>>>> /drivers/net/sky2.c
 
+<<<<<<< HEAD/drivers/net/sky2.c
 		sky2_pci_write32(hw, PCI_CFG_REG_1, 0);
 
 		/* Enable workaround for dev 4.107 on Yukon-Ultra & Extreme */
@@ -257,6 +286,13 @@ static void sky2_power_aux(struct sky2_h
 		sky2_write8(hw, B0_POWER_CTRL,
 			    (PC_VAUX_ENA | PC_VCC_ENA |
 			     PC_VAUX_ON | PC_VCC_OFF));
+=======
+	/* switch power to VAUX */
+	if (sky2_read16(hw, B0_CTST) & Y2_VAUX_AVAIL)
+		sky2_write8(hw, B0_POWER_CTRL,
+			    (PC_VAUX_ENA | PC_VCC_ENA |
+			     PC_VAUX_ON | PC_VCC_OFF));
+>>>>>>> /drivers/net/sky2.c
 }
 
 static void sky2_gmac_reset(struct sky2_hw *hw, unsigned port)
@@ -2631,7 +2667,19 @@ static void sky2_reset(struct sky2_hw *h
 		sky2_pci_write32(hw, PEX_UNC_ERR_STAT, 0xffffffffUL);
 
 
+<<<<<<< HEAD/drivers/net/sky2.c
 	sky2_power_on(hw);
+=======
+	hw->pmd_type = sky2_read8(hw, B2_PMD_TYP);
+	hw->ports = 1;
+	t8 = sky2_read8(hw, B2_Y2_HW_RES);
+	if ((t8 & CFG_DUAL_MAC_MSK) == CFG_DUAL_MAC_MSK) {
+		if (!(sky2_read8(hw, B2_Y2_CLK_GATE) & Y2_STATUS_LNK2_INAC))
+			++hw->ports;
+	}
+
+	sky2_power_on(hw);
+>>>>>>> /drivers/net/sky2.c
 
 	for (i = 0; i < hw->ports; i++) {
 		sky2_write8(hw, SK_REG(i, GMAC_LINK_CTRL), GMLC_RST_SET);
@@ -3901,7 +3949,11 @@ static int __devinit sky2_probe(struct p
 {
 	struct net_device *dev;
 	struct sky2_hw *hw;
+<<<<<<< HEAD/drivers/net/sky2.c
 	int err, using_dac = 0, wol_default;
+=======
+	int err, using_dac = 0;
+>>>>>>> /drivers/net/sky2.c
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -4103,10 +4155,14 @@ #ifdef CONFIG_PM
 static int sky2_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct sky2_hw *hw = pci_get_drvdata(pdev);
+<<<<<<< HEAD/drivers/net/sky2.c
 	int i, wol = 0;
 
 	if (!hw)
 		return 0;
+=======
+	int i;
+>>>>>>> /drivers/net/sky2.c
 
 	del_timer_sync(&hw->idle_timer);
 	netif_poll_disable(hw->dev[0]);
@@ -4125,12 +4181,21 @@ static int sky2_suspend(struct pci_dev *
 	}
 
 	sky2_write32(hw, B0_IMSK, 0);
+<<<<<<< HEAD/drivers/net/sky2.c
 	sky2_power_aux(hw);
 
+=======
+	sky2_power_aux(hw);
+>>>>>>> /drivers/net/sky2.c
 	pci_save_state(pdev);
+<<<<<<< HEAD/drivers/net/sky2.c
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), wol);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
+=======
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+>>>>>>> /drivers/net/sky2.c
 	return 0;
 }
 
@@ -4139,12 +4204,24 @@ static int sky2_resume(struct pci_dev *p
 	struct sky2_hw *hw = pci_get_drvdata(pdev);
 	int i, err;
 
+<<<<<<< HEAD/drivers/net/sky2.c
 	if (!hw)
 		return 0;
 
 	err = pci_set_power_state(pdev, PCI_D0);
 	if (err)
 		goto out;
+=======
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err)
+		goto out;
+
+	err = pci_restore_state(pdev);
+	if (err)
+		goto out;
+
+	pci_enable_wake(pdev, PCI_D0, 0);
+>>>>>>> /drivers/net/sky2.c
 
 	err = pci_restore_state(pdev);
 	if (err)
@@ -4177,8 +4254,13 @@ static int sky2_resume(struct pci_dev *p
 	sky2_idle_start(hw);
 	return 0;
 out:
+<<<<<<< HEAD/drivers/net/sky2.c
 	dev_err(&pdev->dev, "resume failed (%d)\n", err);
 	pci_disable_device(pdev);
+=======
+	printk(KERN_ERR PFX "%s: resume failed (%d)\n", pci_name(pdev), err);
+	pci_disable_device(pdev);
+>>>>>>> /drivers/net/sky2.c
 	return err;
 }
 #endif
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 590b12c..30b2178 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -317,12 +317,21 @@ spider_net_free_chain(struct spider_net_
 	descr = chain->ring;
 	do {
 		descr->bus_addr = 0;
+<<<<<<< HEAD/drivers/net/spider_net.c
 		descr->hwdescr->next_descr_addr = 0;
 		descr = descr->next;
 	} while (descr != chain->ring);
 
 	dma_free_coherent(&card->pdev->dev, chain->num_desc,
 	    chain->hwring, chain->dma_addr);
+=======
+		descr->next_descr_addr = 0;
+		descr = descr->next;
+	} while (descr != chain->ring);
+
+	dma_free_coherent(&card->pdev->dev, chain->num_desc,
+	    chain->ring, chain->dma_addr);
+>>>>>>> /drivers/net/spider_net.c
 }
 
 /**
@@ -343,18 +352,38 @@ spider_net_init_chain(struct spider_net_
 	struct spider_net_descr *descr;
 	struct spider_net_hw_descr *hwdescr;
 	dma_addr_t buf;
+<<<<<<< HEAD/drivers/net/spider_net.c
 	size_t alloc_size;
 
 	alloc_size = chain->num_desc * sizeof(struct spider_net_hw_descr);
+=======
+	size_t alloc_size;
+
+	alloc_size = chain->num_desc * sizeof (struct spider_net_descr);
+>>>>>>> /drivers/net/spider_net.c
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	chain->hwring = dma_alloc_coherent(&card->pdev->dev, alloc_size,
 		&chain->dma_addr, GFP_KERNEL);
+=======
+	chain->ring = dma_alloc_coherent(&card->pdev->dev, alloc_size,
+		&chain->dma_addr, GFP_KERNEL);
+>>>>>>> /drivers/net/spider_net.c
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	if (!chain->hwring)
 		return -ENOMEM;
 
 	memset(chain->ring, 0, chain->num_desc * sizeof(struct spider_net_descr));
+=======
+	if (!chain->ring)
+		return -ENOMEM;
 
+	descr = chain->ring;
+	memset(descr, 0, alloc_size);
+>>>>>>> /drivers/net/spider_net.c
+
+<<<<<<< HEAD/drivers/net/spider_net.c
 	/* Set up the hardware pointers in each descriptor */
 	descr = chain->ring;
 	hwdescr = chain->hwring;
@@ -362,13 +391,24 @@ spider_net_init_chain(struct spider_net_
 	for (i=0; i < chain->num_desc; i++, descr++, hwdescr++) {
 		hwdescr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 		hwdescr->next_descr_addr = 0;
+=======
+	/* Set up the hardware pointers in each descriptor */
+	buf = chain->dma_addr;
+	for (i=0; i < chain->num_desc; i++, descr++) {
+		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
+>>>>>>> /drivers/net/spider_net.c
 
 		descr->hwdescr = hwdescr;
 		descr->bus_addr = buf;
+		descr->next_descr_addr = 0;
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 		buf += sizeof(struct spider_net_hw_descr);
+=======
+		buf += sizeof(struct spider_net_descr);
+>>>>>>> /drivers/net/spider_net.c
 	}
 	/* do actual circular list */
 	(descr-1)->next = chain->ring;
@@ -460,9 +500,14 @@ spider_net_prepare_rx_descr(struct spide
 		card->spider_stats.rx_iommu_map_error++;
 		hwdescr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	} else {
+<<<<<<< HEAD/drivers/net/spider_net.c
 		hwdescr->buf_addr = buf;
 		wmb();
 		hwdescr->dmac_cmd_status = SPIDER_NET_DESCR_CARDOWNED |
+=======
+		wmb();
+		descr->dmac_cmd_status = SPIDER_NET_DESCR_CARDOWNED |
+>>>>>>> /drivers/net/spider_net.c
 					 SPIDER_NET_DMAC_NOINTR_COMPLETE;
 	}
 
@@ -562,9 +607,16 @@ spider_net_alloc_rx_skbs(struct spider_n
 		descr = descr->next;
 	} while (descr != start);
 
+<<<<<<< HEAD/drivers/net/spider_net.c
+	/* Put at least one buffer into the chain. if this fails,
+	 * we've got a problem. If not, spider_net_refill_rx_chain
+	 * will do the rest at the end of this function. */
+=======
+	chain = &card->rx_chain;
 	/* Put at least one buffer into the chain. if this fails,
 	 * we've got a problem. If not, spider_net_refill_rx_chain
 	 * will do the rest at the end of this function. */
+>>>>>>> /drivers/net/spider_net.c
 	if (spider_net_prepare_rx_descr(card, chain->head))
 		goto error;
 	else
@@ -984,8 +1036,13 @@ spider_net_pass_skb_up(struct spider_net
 	struct net_device *netdev;
 	u32 data_status, data_error;
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	data_status = hwdescr->data_status;
 	data_error = hwdescr->data_error;
+=======
+	data_status = descr->data_status;
+	data_error = descr->data_error;
+>>>>>>> /drivers/net/spider_net.c
 	netdev = card->netdev;
 
 	skb = descr->skb;
@@ -1014,10 +1071,26 @@ #define SPIDER_MISALIGN		2
 		 */
 	}
 
+<<<<<<< HEAD/drivers/net/spider_net.c
+=======
+	/* pass skb up to stack */
+	netif_receive_skb(skb);
+
+>>>>>>> /drivers/net/spider_net.c
 	/* update netdevice statistics */
 	card->netdev_stats.rx_packets++;
 	card->netdev_stats.rx_bytes += skb->len;
+}
 
+#ifdef DEBUG
+static void show_rx_chain(struct spider_net_card *card)
+{
+	struct spider_net_descr_chain *chain = &card->rx_chain;
+	struct spider_net_descr *start= chain->tail;
+	struct spider_net_descr *descr= start;
+	int status;
+
+<<<<<<< HEAD/drivers/net/spider_net.c
 	/* pass skb up to stack */
 	netif_receive_skb(skb);
 }
@@ -1168,18 +1241,48 @@ static int spider_net_resync_tail_ptr(st
 	if ((i == chain->num_desc) || (i == 0))
 		return 1;
 	return 0;
+=======
+	int cnt = 0;
+	int cstat = spider_net_get_descr_status(descr);
+	printk(KERN_INFO "RX chain tail at descr=%ld\n",
+	     (start - card->descr) - card->tx_chain.num_desc);
+	status = cstat;
+	do
+	{
+		status = spider_net_get_descr_status(descr);
+		if (cstat != status) {
+			printk(KERN_INFO "Have %d descrs with stat=x%08x\n", cnt, cstat);
+			cstat = status;
+			cnt = 0;
+		}
+		cnt ++;
+		descr = descr->next;
+	} while (descr != start);
+	printk(KERN_INFO "Last %d descrs with stat=x%08x\n", cnt, cstat);
+>>>>>>> /drivers/net/spider_net.c
 }
+#endif
 
 /**
  * spider_net_decode_one_descr - processes an RX descriptor
  * @card: card structure
  *
+<<<<<<< HEAD/drivers/net/spider_net.c
  * Returns 1 if a packet has been sent to the stack, otherwise 0.
+=======
+ * Returns 1 if a packet has been sent to the stack, otherwise 0
+>>>>>>> /drivers/net/spider_net.c
  *
+<<<<<<< HEAD/drivers/net/spider_net.c
  * Processes an RX descriptor by iommu-unmapping the data buffer
  * and passing the packet up to the stack. This function is called
  * in softirq context, e.g. either bottom half from interrupt or
  * NAPI polling context.
+=======
+ * Processes an rx descriptor by iommu-unmapping the data buffer and passing
+ * the packet up to the stack. This function is called in softirq
+ * context, e.g. either bottom half from interrupt or NAPI polling context
+>>>>>>> /drivers/net/spider_net.c
  */
 static int
 spider_net_decode_one_descr(struct spider_net_card *card)
@@ -1200,12 +1303,19 @@ spider_net_decode_one_descr(struct spide
 	/* descriptor definitively used -- move on tail */
 	chain->tail = descr->next;
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	/* unmap descriptor */
 	hw_buf_addr = hwdescr->buf_addr;
 	hwdescr->buf_addr = 0xffffffff;
 	pci_unmap_single(card->pdev, hw_buf_addr,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
 
+=======
+	/* unmap descriptor */
+	pci_unmap_single(card->pdev, descr->buf_addr,
+			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
+
+>>>>>>> /drivers/net/spider_net.c
 	if ( (status == SPIDER_NET_DESCR_RESPONSE_ERROR) ||
 	     (status == SPIDER_NET_DESCR_PROTECTION_ERROR) ||
 	     (status == SPIDER_NET_DESCR_FORCE_END) ) {
@@ -1218,6 +1328,7 @@ spider_net_decode_one_descr(struct spide
 
 	if ( (status != SPIDER_NET_DESCR_COMPLETE) &&
 	     (status != SPIDER_NET_DESCR_FRAME_END) ) {
+<<<<<<< HEAD/drivers/net/spider_net.c
 		if (netif_msg_rx_err(card))
 			dev_err(&card->netdev->dev,
 			       "RX descriptor with unknown state %d\n", status);
@@ -1249,8 +1360,44 @@ spider_net_decode_one_descr(struct spide
 
 		card->spider_stats.rx_desc_error++;
 		goto bad_desc;
+=======
+		if (netif_msg_rx_err(card))
+			pr_err("%s: RX descriptor with unkown state %d\n",
+			       card->netdev->name, status);
+		card->spider_stats.rx_desc_unk_state++;
+		goto bad_desc;
+	}
+
+	/* The cases we'll throw away the packet immediately */
+	if (descr->data_error & SPIDER_NET_DESTROY_RX_FLAGS) {
+		if (netif_msg_rx_err(card))
+			pr_err("%s: error in received descriptor found, "
+			       "data_status=x%08x, data_error=x%08x\n",
+			       card->netdev->name,
+			       descr->data_status, descr->data_error);
+		goto bad_desc;
+	}
+
+	if (descr->dmac_cmd_status & 0xfefe) {
+		pr_err("%s: bad status, cmd_status=x%08x\n",
+			       card->netdev->name,
+			       descr->dmac_cmd_status);
+		pr_err("buf_addr=x%08x\n", descr->buf_addr);
+		pr_err("buf_size=x%08x\n", descr->buf_size);
+		pr_err("next_descr_addr=x%08x\n", descr->next_descr_addr);
+		pr_err("result_size=x%08x\n", descr->result_size);
+		pr_err("valid_size=x%08x\n", descr->valid_size);
+		pr_err("data_status=x%08x\n", descr->data_status);
+		pr_err("data_error=x%08x\n", descr->data_error);
+		pr_err("bus_addr=x%08x\n", descr->bus_addr);
+		pr_err("which=%ld\n", descr - card->rx_chain.ring);
+
+		card->spider_stats.rx_desc_error++;
+		goto bad_desc;
+>>>>>>> /drivers/net/spider_net.c
 	}
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	/* Ok, we've got a packet in descr */
 	spider_net_pass_skb_up(descr, card);
 	descr->skb = NULL;
@@ -1264,6 +1411,17 @@ bad_desc:
 	descr->skb = NULL;
 	hwdescr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	return 0;
+=======
+	/* Ok, we've got a packet in descr */
+	spider_net_pass_skb_up(descr, card);
+	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
+	return 1;
+
+bad_desc:
+	dev_kfree_skb_irq(descr->skb);
+	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
+	return 0;
+>>>>>>> /drivers/net/spider_net.c
 }
 
 /**
@@ -1307,9 +1465,13 @@ spider_net_poll(struct net_device *netde
 	netdev->quota -= packets_done;
 	*budget -= packets_done;
 	spider_net_refill_rx_chain(card);
+<<<<<<< HEAD/drivers/net/spider_net.c
 	spider_net_enable_rxdmac(card);
 
 	spider_net_cleanup_tx_ring(card);
+=======
+	spider_net_enable_rxdmac(card);
+>>>>>>> /drivers/net/spider_net.c
 
 	/* if all packets are in the stack, enable interrupts and return 0 */
 	/* if not, return 1 */
@@ -1403,6 +1565,7 @@ spider_net_set_mac(struct net_device *ne
 }
 
 /**
+<<<<<<< HEAD/drivers/net/spider_net.c
  * spider_net_link_reset
  * @netdev: net device structure
  *
@@ -1430,6 +1593,8 @@ spider_net_link_reset(struct net_device 
 }
 
 /**
+=======
+>>>>>>> /drivers/net/spider_net.c
  * spider_net_handle_error_irq - handles errors raised by an interrupt
  * @card: card structure
  * @status_reg: interrupt status register 0 (GHIINT0STS)
@@ -1556,6 +1721,7 @@ spider_net_handle_error_irq(struct spide
 	case SPIDER_NET_GRFBFLLINT: /* fallthrough */
 	case SPIDER_NET_GRFAFLLINT: /* fallthrough */
 	case SPIDER_NET_GRMFLLINT:
+<<<<<<< HEAD/drivers/net/spider_net.c
 		/* Could happen when rx chain is full */
 		if (card->ignore_rx_ramfull == 0) {
 			card->ignore_rx_ramfull = 1;
@@ -1565,6 +1731,13 @@ spider_net_handle_error_irq(struct spide
 			card->num_rx_ints ++;
 			netif_rx_schedule(card->netdev);
 		}
+=======
+		if (netif_msg_intr(card) && net_ratelimit())
+			pr_err("Spider RX RAM full, incoming packets "
+			       "might be discarded!\n");
+		spider_net_rx_irq_off(card);
+		netif_rx_schedule(card->netdev);
+>>>>>>> /drivers/net/spider_net.c
 		show_error = 0;
 		break;
 
@@ -1579,7 +1752,14 @@ spider_net_handle_error_irq(struct spide
 	case SPIDER_NET_GDCDCEINT: /* fallthrough */
 	case SPIDER_NET_GDBDCEINT: /* fallthrough */
 	case SPIDER_NET_GDADCEINT:
+<<<<<<< HEAD/drivers/net/spider_net.c
 		spider_net_resync_head_ptr(card);
+=======
+		if (netif_msg_intr(card) && net_ratelimit())
+			pr_err("got descriptor chain end interrupt, "
+			       "restarting DMAC %c.\n",
+			       'D'-(i-SPIDER_NET_GDDDCEINT)/3);
+>>>>>>> /drivers/net/spider_net.c
 		spider_net_refill_rx_chain(card);
 		spider_net_enable_rxdmac(card);
 		card->num_rx_ints ++;
@@ -1652,8 +1832,13 @@ spider_net_handle_error_irq(struct spide
 			break;
 	}
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	if ((show_error) && (netif_msg_intr(card)) && net_ratelimit())
 		dev_err(&card->netdev->dev, "Error interrupt, GHIINT0STS = 0x%08x, "
+=======
+	if ((show_error) && (netif_msg_intr(card)) && net_ratelimit())
+		pr_err("Got error interrupt on %s, GHIINT0STS = 0x%08x, "
+>>>>>>> /drivers/net/spider_net.c
 		       "GHIINT1STS = 0x%08x, GHIINT2STS = 0x%08x\n",
 		       status_reg, error_reg1, error_reg2);
 
@@ -1869,6 +2054,109 @@ spider_net_enable_card(struct spider_net
 }
 
 /**
+<<<<<<< HEAD/drivers/net/spider_net.c
+=======
+ * spider_net_open - called upon ifonfig up
+ * @netdev: interface device structure
+ *
+ * returns 0 on success, <0 on failure
+ *
+ * spider_net_open allocates all the descriptors and memory needed for
+ * operation, sets up multicast list and enables interrupts
+ */
+int
+spider_net_open(struct net_device *netdev)
+{
+	struct spider_net_card *card = netdev_priv(netdev);
+	struct spider_net_descr *descr;
+	int result;
+
+	result = spider_net_init_chain(card, &card->tx_chain);
+	if (result)
+		goto alloc_tx_failed;
+	card->low_watermark = NULL;
+
+	result = spider_net_init_chain(card, &card->rx_chain);
+	if (result)
+		goto alloc_rx_failed;
+
+	/* Make a ring of of bus addresses */
+	descr = card->rx_chain.ring;
+	do {
+		descr->next_descr_addr = descr->next->bus_addr;
+		descr = descr->next;
+	} while (descr != card->rx_chain.ring);
+
+	/* Allocate rx skbs */
+	if (spider_net_alloc_rx_skbs(card))
+		goto alloc_skbs_failed;
+
+	spider_net_set_multi(netdev);
+
+	/* further enhancement: setup hw vlan, if needed */
+
+	result = -EBUSY;
+	if (request_irq(netdev->irq, spider_net_interrupt,
+			     IRQF_SHARED, netdev->name, netdev))
+		goto register_int_failed;
+
+	spider_net_enable_card(card);
+
+	netif_start_queue(netdev);
+	netif_carrier_on(netdev);
+	netif_poll_enable(netdev);
+
+	return 0;
+
+register_int_failed:
+	spider_net_free_rx_chain_contents(card);
+alloc_skbs_failed:
+	spider_net_free_chain(card, &card->rx_chain);
+alloc_rx_failed:
+	spider_net_free_chain(card, &card->tx_chain);
+alloc_tx_failed:
+	return result;
+}
+
+/**
+ * spider_net_setup_phy - setup PHY
+ * @card: card structure
+ *
+ * returns 0 on success, <0 on failure
+ *
+ * spider_net_setup_phy is used as part of spider_net_probe. Sets
+ * the PHY to 1000 Mbps
+ **/
+static int
+spider_net_setup_phy(struct spider_net_card *card)
+{
+	struct mii_phy *phy = &card->phy;
+
+	spider_net_write_reg(card, SPIDER_NET_GDTDMASEL,
+			     SPIDER_NET_DMASEL_VALUE);
+	spider_net_write_reg(card, SPIDER_NET_GPCCTRL,
+			     SPIDER_NET_PHY_CTRL_VALUE);
+	phy->mii_id = 1;
+	phy->dev = card->netdev;
+	phy->mdio_read = spider_net_read_phy;
+	phy->mdio_write = spider_net_write_phy;
+
+	mii_phy_probe(phy, phy->mii_id);
+
+	if (phy->def->ops->setup_forced)
+		phy->def->ops->setup_forced(phy, SPEED_1000, DUPLEX_FULL);
+
+	phy->def->ops->enable_fiber(phy);
+
+	phy->def->ops->read_link(phy);
+	pr_info("Found %s with %i Mbps, %s-duplex.\n", phy->def->name,
+		phy->speed, phy->duplex==1 ? "Full" : "Half");
+
+	return 0;
+}
+
+/**
+>>>>>>> /drivers/net/spider_net.c
  * spider_net_download_firmware - loads firmware into the adapter
  * @card: card structure
  * @firmware_ptr: pointer to firmware data
@@ -2355,6 +2643,12 @@ spider_net_setup_netdev(struct spider_ne
 
 	card->options.rx_csum = SPIDER_NET_RX_CSUM_DEFAULT;
 
+<<<<<<< HEAD/drivers/net/spider_net.c
+=======
+	card->tx_chain.num_desc = tx_descriptors;
+	card->rx_chain.num_desc = rx_descriptors;
+
+>>>>>>> /drivers/net/spider_net.c
 	spider_net_setup_netdev_ops(netdev);
 
 	netdev->features = NETIF_F_IP_CSUM | NETIF_F_LLTX;
@@ -2405,11 +2699,14 @@ spider_net_alloc_card(void)
 {
 	struct net_device *netdev;
 	struct spider_net_card *card;
-	size_t alloc_size;
 
+<<<<<<< HEAD/drivers/net/spider_net.c
 	alloc_size = sizeof(struct spider_net_card) +
 	   (tx_descriptors + rx_descriptors) * sizeof(struct spider_net_descr);
 	netdev = alloc_etherdev(alloc_size);
+=======
+	netdev = alloc_etherdev(sizeof(struct spider_net_card));
+>>>>>>> /drivers/net/spider_net.c
 	if (!netdev)
 		return NULL;
 
diff --git a/drivers/net/spider_net.h b/drivers/net/spider_net.h
index dbbdb8c..8854be0 100644
--- a/drivers/net/spider_net.h
+++ b/drivers/net/spider_net.h
@@ -25,7 +25,11 @@
 #ifndef _SPIDER_NET_H
 #define _SPIDER_NET_H
 
+<<<<<<< HEAD/drivers/net/spider_net.h
 #define VERSION "2.0 B"
+=======
+#define VERSION "1.6 B"
+>>>>>>> /drivers/net/spider_net.h
 
 #include "sungem_phy.h"
 
@@ -407,10 +411,16 @@ struct spider_net_descr_chain {
 	spinlock_t lock;
 	struct spider_net_descr *head;
 	struct spider_net_descr *tail;
+<<<<<<< HEAD/drivers/net/spider_net.h
 	struct spider_net_descr *ring;
 	int num_desc;
 	struct spider_net_hw_descr *hwring;
 	dma_addr_t dma_addr;
+=======
+	struct spider_net_descr *ring;
+	int num_desc;
+	dma_addr_t dma_addr;
+>>>>>>> /drivers/net/spider_net.h
 };
 
 /* descriptor data_status bits */
@@ -474,8 +484,11 @@ struct spider_net_card {
 	struct spider_net_descr_chain rx_chain;
 	struct spider_net_descr *low_watermark;
 
+<<<<<<< HEAD/drivers/net/spider_net.h
 	int aneg_count;
 	struct timer_list aneg_timer;
+=======
+>>>>>>> /drivers/net/spider_net.h
 	struct timer_list tx_timer;
 	struct work_struct tx_timeout_task;
 	atomic_t tx_timeout_task_counter;
@@ -487,10 +500,14 @@ struct spider_net_card {
 	int msg_enable;
 	struct net_device_stats netdev_stats;
 	struct spider_net_extra_stats spider_stats;
+<<<<<<< HEAD/drivers/net/spider_net.h
 	struct spider_net_options options;
 
 	/* Must be last item in struct */
 	struct spider_net_descr darray[0];
+=======
+	struct spider_net_options options;
+>>>>>>> /drivers/net/spider_net.h
 };
 
 #define pr_err(fmt,arg...) \
diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 65ad2e2..38f9ad1 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -222,6 +222,7 @@ int hdlc_ioctl(struct net_device *dev, s
 	return -EINVAL;
 }
 
+<<<<<<< HEAD/drivers/net/wan/hdlc.c
 static void hdlc_setup_dev(struct net_device *dev)
 {
 	/* Re-init all variables changed by HDLC protocol drivers,
@@ -243,6 +244,9 @@ static void hdlc_setup_dev(struct net_de
 }
 
 static void hdlc_setup(struct net_device *dev)
+=======
+static void hdlc_setup(struct net_device *dev)
+>>>>>>> /drivers/net/wan/hdlc.c
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index c39f198..0856390 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -814,7 +814,11 @@ static int hw_init_hmac(struct zd_chip *
 	if (r)
 		return r;
 
+<<<<<<< HEAD/drivers/net/wireless/zd1211rw/zd_chip.c
 	return zd_chip_is_zd1211b(chip) ?
+=======
+	return chip->is_zd1211b ?
+>>>>>>> /drivers/net/wireless/zd1211rw/zd_chip.c
 		zd1211b_hw_init_hmac(chip) : zd1211_hw_init_hmac(chip);
 }
 
@@ -1061,6 +1065,7 @@ int zd_chip_disable_hwint(struct zd_chip
 	return r;
 }
 
+<<<<<<< HEAD/drivers/net/wireless/zd1211rw/zd_chip.c
 static int read_fw_regs_offset(struct zd_chip *chip)
 {
 	int r;
@@ -1085,6 +1090,25 @@ int zd_chip_read_mac_addr_fw(struct zd_c
 }
 
 int zd_chip_init_hw(struct zd_chip *chip)
+=======
+static int read_fw_regs_offset(struct zd_chip *chip)
+{
+	int r;
+
+	ZD_ASSERT(mutex_is_locked(&chip->mutex));
+	r = zd_ioread16_locked(chip, (u16*)&chip->fw_regs_base,
+		               FWRAW_REGS_ADDR);
+	if (r)
+		return r;
+	dev_dbg_f(zd_chip_dev(chip), "fw_regs_base: %#06hx\n",
+		  (u16)chip->fw_regs_base);
+
+	return 0;
+}
+
+
+int zd_chip_init_hw(struct zd_chip *chip, u8 device_type)
+>>>>>>> /drivers/net/wireless/zd1211rw/zd_chip.c
 {
 	int r;
 	u8 rf_type;
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 8009b70..7594b59 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -644,6 +644,7 @@ #define E2P_PWR_INT_VALUE4	E2P_DATA(0x16
  * also only 11 channels. */
 #define E2P_ALLOWED_CHANNEL	E2P_DATA(0x18)
 
+<<<<<<< HEAD/drivers/net/wireless/zd1211rw/zd_chip.h
 #define E2P_DEVICE_VER		E2P_DATA(0x20)
 #define E2P_PHY_REG		E2P_DATA(0x25)
 #define E2P_36M_CAL_VALUE1	E2P_DATA(0x28)
@@ -670,6 +671,34 @@ #define E2P_54M_INT_VALUE1	E2P_DATA(0x50
 #define E2P_54M_INT_VALUE2	E2P_DATA(0x52)
 #define E2P_54M_INT_VALUE3	E2P_DATA(0x54)
 #define E2P_54M_INT_VALUE4	E2P_DATA(0x56)
+=======
+#define E2P_PHY_REG		E2P_DATA(0x1a)
+#define E2P_DEVICE_VER		E2P_DATA(0x20)
+#define E2P_36M_CAL_VALUE1	E2P_DATA(0x28)
+#define E2P_36M_CAL_VALUE2      E2P_DATA(0x2a)
+#define E2P_36M_CAL_VALUE3      E2P_DATA(0x2c)
+#define E2P_36M_CAL_VALUE4	E2P_DATA(0x2e)
+#define E2P_11A_INT_VALUE1	E2P_DATA(0x30)
+#define E2P_11A_INT_VALUE2	E2P_DATA(0x32)
+#define E2P_11A_INT_VALUE3	E2P_DATA(0x34)
+#define E2P_11A_INT_VALUE4	E2P_DATA(0x36)
+#define E2P_48M_CAL_VALUE1	E2P_DATA(0x38)
+#define E2P_48M_CAL_VALUE2	E2P_DATA(0x3a)
+#define E2P_48M_CAL_VALUE3	E2P_DATA(0x3c)
+#define E2P_48M_CAL_VALUE4	E2P_DATA(0x3e)
+#define E2P_48M_INT_VALUE1	E2P_DATA(0x40)
+#define E2P_48M_INT_VALUE2	E2P_DATA(0x42)
+#define E2P_48M_INT_VALUE3	E2P_DATA(0x44)
+#define E2P_48M_INT_VALUE4	E2P_DATA(0x46)
+#define E2P_54M_CAL_VALUE1	E2P_DATA(0x48)	/* ??? */
+#define E2P_54M_CAL_VALUE2	E2P_DATA(0x4a)
+#define E2P_54M_CAL_VALUE3	E2P_DATA(0x4c)
+#define E2P_54M_CAL_VALUE4	E2P_DATA(0x4e)
+#define E2P_54M_INT_VALUE1	E2P_DATA(0x50)
+#define E2P_54M_INT_VALUE2	E2P_DATA(0x52)
+#define E2P_54M_INT_VALUE3	E2P_DATA(0x54)
+#define E2P_54M_INT_VALUE4	E2P_DATA(0x56)
+>>>>>>> /drivers/net/wireless/zd1211rw/zd_chip.h
 
 /* This word contains the base address of the FW_REG_ registers below */
 #define FWRAW_REGS_ADDR		FWRAW_DATA(0x1d)
@@ -702,8 +731,14 @@ struct zd_chip {
 	struct zd_usb usb;
 	struct zd_rf rf;
 	struct mutex mutex;
+<<<<<<< HEAD/drivers/net/wireless/zd1211rw/zd_chip.h
+	/* Base address of FW_REG_ registers */
+	zd_addr_t fw_regs_base;
+=======
 	/* Base address of FW_REG_ registers */
 	zd_addr_t fw_regs_base;
+	u8 e2p_mac[ETH_ALEN];
+>>>>>>> /drivers/net/wireless/zd1211rw/zd_chip.h
 	/* EepSetPoint in the vendor driver */
 	u8 pwr_cal_values[E2P_CHANNEL_COUNT];
 	/* integration values in the vendor driver */
diff --git a/drivers/net/wireless/zd1211rw/zd_def.h b/drivers/net/wireless/zd1211rw/zd_def.h
index 505b4d7..5ba9e7d 100644
--- a/drivers/net/wireless/zd1211rw/zd_def.h
+++ b/drivers/net/wireless/zd1211rw/zd_def.h
@@ -24,6 +24,8 @@ #include <linux/device.h>
 
 typedef u16 __nocast zd_addr_t;
 
+typedef u16 __nocast zd_addr_t;
+
 #define dev_printk_f(level, dev, fmt, args...) \
 	dev_printk(level, dev, "%s() " fmt, __func__, ##args)
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index a9c339e..c2e5806 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -61,6 +61,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
+<<<<<<< HEAD/drivers/net/wireless/zd1211rw/zd_usb.c
 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
@@ -74,6 +75,12 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
+=======
+	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
+>>>>>>> /drivers/net/wireless/zd1211rw/zd_usb.c
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 961a7a1..d527bc5 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -188,7 +188,10 @@ struct zd_usb {
 	struct zd_usb_rx rx;
 	struct zd_usb_tx tx;
 	struct usb_interface *intf;
+<<<<<<< HEAD/drivers/net/wireless/zd1211rw/zd_usb.h
 	u8 is_zd1211b:1, initialized:1;
+=======
+>>>>>>> /drivers/net/wireless/zd1211rw/zd_usb.h
 };
 
 #define zd_usb_dev(usb) (&usb->intf->dev)

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
git-r8169.patch
