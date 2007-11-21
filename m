From: akpm@linux-foundation.org
Subject: - git-ipwireless_cs.patch removed from -mm tree
Date: Wed, 21 Nov 2007 15:13:57 -0800
Message-ID: <200711212313.lALNDv6E014246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbXKUXS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Nov 2007 18:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsterba@suse.cz, akpm@linux-foundation.orgakpm@linux-foundation.org, benm@symmetric.co.nz, bunk@stusta.de, chsmith@ipwireless.com, jkosina@suse.cz, michal.rokos@gmail.com, pavel@pal


The patch titled
     git-ipwireless_cs.patch
has been removed from the -mm tree.  Its filename was
     git-ipwireless_cs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-ipwireless_cs.patch

GIT 92808f49b1b3231883cb93aa2d5789798ff84586 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git#ipw-devel

commit 92808f49b1b3231883cb93aa2d5789798ff84586
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 19 14:01:33 2007 +0100

    ipwireless_cs: Remove intra-func locking
    
    Remove intra-func locking starting in tasklet handler.
    
    * audit callchain from tasklet handler and to let all funcs be
      called unlocked and take only local spinlocks saving flags
    * remove locks around readonly variables of hw (ll_mtu, port
      base, version)
    * add locks to shared variable: rx_bytes_queued
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 1e3ac661f782bbe225bcc15ac33db3f8a4b17bff
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 19:30:00 2007 +0100

    Remove unused variable
    
    Remove unused variable.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3c9a18e8330dc800416efa54b8f8c48ef4ef1039
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 19:29:55 2007 +0100

    Reduce dev node count
    
    Reduce number of dev_node_t nodes, currently using only 2.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit a035b3f5df156828dd316d2631015289ec62ff71
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 19:29:50 2007 +0100

    Merge some variables
    
    Merge temporary variable declarations.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 64c1513f828f76b7ab687c15d620576deac0749b
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 19:29:45 2007 +0100

    add_tty: Let caller set the minor number
    
    Dont' change index indirectly in calee, do it in caller, it's more clear.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit fbad1ad13b9bd64cf91af6f811ca8cdf8611d64e
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 19:29:40 2007 +0100

    Reduce variables: major number
    
    Take tty major number from driver, no need to store it in extra variable.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit afa43b8fdee7e976deebea2f1e92121f41b35e82
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 19:29:34 2007 +0100

    add_tty: Pass dev node pointer directly
    
    Pass dev node pointer directly
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit a6c318a8dd1ef3ecb5f34cf423064ccb05975880
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 18:26:20 2007 +0100

    Remove unnecessary parameter
    
    Remove unnecessary parameter ipw_hardware from packet callbacks.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit accf7949121972ab68dd120865d253e6635339e0
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 18:13:36 2007 +0100

    Remove rest of console channel code
    
    Remove name of console channel, replace hardcoded values for tty device minor
    number with defines.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit abd1a4976348a665cbfebef9c63cc15cecaac36f
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 15:35:55 2007 +0100

    Remove unneded typecasts
    
    Remove unneded typecasts of tty driver_data.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 17a69421ed780e2a15f441f10677f94ab9e8cc07
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 15:35:50 2007 +0100

    Reduce function nesting bloat in tty
    
    Remove call from ipw_ioctl to ppp_ioctl (misleading name ...), and put the
    code inline.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 504fab9270582e98fe85c869cc6336082cf77c8e
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 12:31:04 2007 +0100

    ipwireless_cs: Remove unused data from network sturcture
    
    Remove unused data from network sturcture:
    * modem reply buffers, no AT processing is done
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 2556ca1e1a7e451ceae1587144bf80671ad1b541
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 12:30:59 2007 +0100

    ipwireless_cs: Comment on PPP ioctl
    
    Comment on PPP ioctl data and origin of ioctl handler.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit bee130626b6e2c26db99b49eb82fbbc1c35e0f0a
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 11:37:02 2007 +0100

    ipwireless_cs: Use PPP constants
    
    Use proper PPP constants instead of hard values.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 2c5f4de9436a00ace6286aa29eea077b8cd8beb2
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 11:36:57 2007 +0100

    ipwireless_cs: Networking code cleanups
    
    Cleanup skb allocating code, rename the func.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit e45b0a2dfc825a1ed760d843184a3ebd3f4faf62
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 11:34:46 2007 +0100

    ipwireless_cs: Handle spurious interrupts
    
    Change V2/V3 interrupt handler so that, 1. If it switches to the OldTx
    mode, it loops back and tries the interrupt handling again, and 2. If it
    has detected the serial number, then spurious interrupts are ignored
    instead of wrongly being considered a reason to switch to OldTx mode.
    This fix supplied by Chris Smith of IPWireless - thanks.
    
    Cc: Chris Smith <chsmith@ipwireless.com>
    Signed-off-by: Ben Martel <benm@symmetric.co.nz>
    Signed-off-by: Stephen Blackheath <stephen@symmetric.co.nz>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit a94c8ab98c2af2f1896bf0c2a4e9fc72c5b8669e
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Nov 8 11:34:40 2007 +0100

    ipwireless_cs: Close tty on DCD
    
    (port from 1.0.17)
    Driver closes the tty when DCD is deasserted, in order to make pppd
    disconnect correctly. - thanks to Simon Patterson - Woosh Wireless.  This
    should server to improve the time it takes to reconnect the port after a
    non-clean disconnect - e.g. loss of radio link
    
    Signed-off-by: Ben Martel <benm@symmetric.co.nz>
    Signed-off-by: Stephen Blackheath <stephen@symmetric.co.nz>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit aeabe51661fd733fbe5a9aca1359e2000c7d4bd1
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Nov 6 12:17:27 2007 +0100

    ipwireless_cs: warning fix
    
    drivers/char/pcmcia/ipwireless_cs_tty.c: In function 'ipwireless_tty_received':
    drivers/char/pcmcia/ipwireless_cs_tty.c:193: warning: unused variable 'i'
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 7519778aaccfa19a750333f60feaf0aa036c582e
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:55:18 2007 +0100

    ipwireless_cs: Add all chars to flip buffer
    
    Add all chars to flip buffer at once. Room is implicitly made inside the
    call.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 5180cd3fc94af2ac44f56969fc027f05edc5bda4
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:55:13 2007 +0100

    ipwireless_cs: Remove tty link to pcmcia
    
    Remove link from tty to pcmcia subsystem -- pcmcia subsystem ignores the
    'open' ref count anyway.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 7877b87293f4e1c37925669eddf6187b06ba60f2
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:55:08 2007 +0100

    ipwireless_cs: Update copyright
    
    Add my copyright to file headers.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit e5804cf16aee09424de4975e417330d50052505f
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:55:03 2007 +0100

    ipwireless_cs: Remove vendor mode
    
    Remove vendor mode.
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit ce32c9c7832fc5d9ce5c80988ae2887ba5b58bf9
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:54:58 2007 +0100

    ipwireless_cs: Minor list cleanups
    
    Minor list cleanups
    * use more list *_entry macros
    * use list_first_entry macros
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 0d1d56494249792ffa738b83420b9b9dbab80807
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:54:53 2007 +0100

    ipwireless_cs: Minor code cleanups
    
    Cleanups:
    * merge tasklet and processing func
    * use ipw_ prefix for workq worker
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 59b8593a6939e433d68375be8f237b7b89a3c714
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:54:48 2007 +0100

    ipwireless_cs: Split hardware setup
    
    Split hardware setup into real hw setup and packet sending.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit abaca13cfa27e83e8b5a38b7d9437e10fe5279ec
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:54:38 2007 +0100

    ipwireless_cs: Unshadow tty variable
    
    Rename a temporary tty variable, to silence warning:
    
    drivers/char/pcmcia/ipwireless_cs_tty.c:575:18: warning: symbol 'tty'
    shadows an earlier one
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 6bb99d7411d8e3c56766b623b6ccd0195dda1ac6
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:54:43 2007 +0100

    ipwireless_cs: Remove IRQInfo2 from pcmcia code
    
    Remove usage of IRQInfo2, it's filled by pcmcia subsystem.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 39de0b0f1f79828ffd176d1efb1260df31683a83
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Nov 5 11:54:32 2007 +0100

    ipwireless_cs: Restart loop in recv
    
    Recv list was intially traversed locked, and unlocked for data processing,
    and list may be used unlocked from elsewhere. In case it's unlocked, start
    over from the begining.
    
    Start over always, since in fact it mimics the same behaviour as before
    and does not have the locking problems.
    
    Original patch posted by Michal Rokos <michal.rokos@gmail.com> and modified
    to not use goto.
    
    Signed-off-by: Michal Rokos <michal.rokos@gmail.com>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 0182ded2dc258d998eb961cf7ce2d23e402da06b
Author: Pavel Palat <pavel@palat.cz>
Date:   Wed Sep 12 16:40:26 2007 +0200

    ipwireless_cs: fallback to old TX register when the card is not responding using TX2
    
    This is a workaround for buggy cards that claim to use tx2 register, but
    (sometimes) use tx.
    
    Reported by Pavel Palat to fix problems on
    
    	CGMR: 5.2.5.65 / A1 (5.0) / A2 (5.0); 5.2.5.65 / REVISION 03.010
    
    Signed-off-by: Pavel Palat <pavel@palat.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit d70694668bb6066c3c8ab4ae3682e4f1c3e06983
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Sep 5 18:57:27 2007 +0200

    ipwireless_cs: Cleanups reported by checkpatch
    
    Cleanups reported by checkpatch
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3b0103d562077766a5c5d795be046947f106a413
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Sep 5 17:34:55 2007 +0200

    ipwireless_cs: Update maintainers file
    
    Update maintainers file.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 5b6bc0943c57dbde05d0aa7d19dc03952c24c878
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Sep 5 17:27:40 2007 +0200

    ipwireless_cs: Remove own tasklet schedule wrapper
    
    Remove own tasklet schedule wrapper, it's safe to schedule tasklet
    unconditionally.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 42e39737f49e81e87d1657c0c1c240969349512c
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Aug 29 12:43:45 2007 +0200

    Fix potential recv list corruption
    
    Fix potential recv list corruption:
    
    ->do_receive_data_work
      spinlock, traverse list_foreach_safe rx_queue list, safe delete members
      call get_packets_from_hw each round
        spin unlock
        ->do_receive_packet
         ->handle_received_packet
          ->queue_received_packet
            spinlock, list_add_tail to rx_queue
    
    Bad interaction between list_foreach_safe and list_add_tail may corrupt
    data and cause crash.
    
    The function call is remainder after do_io cleanups and has no performance
    and functional hit.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 8be868397d8ea10060c1b841c4ababa9c4dcd659
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Aug 27 14:05:02 2007 +0200

    ipwireless_cs: Save irq flags around send_packet
    
    Save irq flags around send_packet, it does not save flags since it is
    called from other parts which do wild spinlocking accross function
    boundaries and cannot correctly save irq flags.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 60b4aff567c8f824bed459e835aa3f3904993bf6
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 28 16:16:26 2007 +0200

    ipwireless_cs: Fix locking around packet recv
    
    Leave packet processing locked when network has been detached and packets
    still arrive. Function callchain is safe to run unlocked.
    
    Signed-off-by: Michal Rokos <michal.rokos@gmail.com>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3792c033f1d0585b9d088ed99f50591862afcbde
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 28 12:05:06 2007 +0200

    ipwireless_cs: Remove _t suffix from struct names
    
    Remove _t suffix from struct names, left by typedef removal.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 92e8c2173f27c5d2d6ef6b5ac89a8a3d2c077ddc
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 28 12:05:01 2007 +0200

    ipwireless_cs: Remove unused types
    
    Remove unused setup types, remove some typedefs.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit fd3ea0e4f28473dcbd241e87945ec562120ee701
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 28 12:04:56 2007 +0200

    ipwireless_cs: Rename setup variables and structs
    
    Rename setup protocol variables, use codingstyle conformant names.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 9d31bffe265eb6a3dd2eca408ac228655c3e3dc3
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 28 12:04:51 2007 +0200

    ipwireless_cs: Cleanup setup protocol types
    
    Cleanup setup protocol types:
    * rename to more conforming names
    * remove typedefs
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 4041c3226cea54b1b13d4769b2ba6dd68736a9fc
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Aug 24 14:46:51 2007 +0200

    ipwireless_cs: Add typecasts
    
    Add typecasts short->int to printed length. Fix address format type.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 83111d8d349402dce1105c3892c122c598e2ce7a
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Aug 24 14:46:46 2007 +0200

    ipwireless_cs: Ack packet reading before handling data
    
    Ack packet reading before handling data and don't block device in recving
    more data in the meantime. Wrap the code into func.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 9ad85eeee710dc46fd70c6fec815cb04bf8ed2f0
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Aug 24 14:46:41 2007 +0200

    ipwireless_cs: Endianity in packet header
    
    Use type to fit the bitfields which does not need the packed attribute.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3cb4d77e301876e1a7aed882f1ea61c2583cc578
Author: Michal Rokos <michal.rokos@gmail.com>
Date:   Fri Aug 24 14:46:36 2007 +0200

    ipwireless_cs: Don't use tx_queue unlocked
    
    In send_packet, tx_queue was read outside of spinlock which could race with
    tx_queue usage in do_send_packet.
    
    Regular data send:
    ipwireless_send_packet
     send_packet
      (init from tx_queue unlocked)
      spinlock
      list_add_tail
    
    Deferred work in tasklet:
    ...
     send_pending_packet
      do_send_packet
       spinlock
       list_add
    
    scenairo:
    
    				do_send_packet
     send_packet
     unlocked usage of tx_queue
     				spinlock
    				list_add_tail
    				spinunlock
     spinlock
     list_add with wrong data
    
    Signed-off-by: Michal Rokos <michal.rokos@gmail.com>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit c5e7beb0badc810f25015cdbde32d44129806832
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Aug 23 15:15:20 2007 +0200

    ipwireless_cs: Proper endianity in send
    
    Properly convert data bytes endianity in packet send.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 68e4a3efee904540dcd542ad82d64d094554792c
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Aug 23 15:15:15 2007 +0200

    ipwireless_cs: Proper endianity in recv
    
    Properly convert data bytes endianity in packet recv.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3eb1006fa173385abfd673bb2bde7e8f5f33cd8b
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Aug 22 16:51:01 2007 +0200

    ipwireless_cs: Use priority parameter when setting line control
    
    Use priority parameter when setting line control. Parameter
    is ignored in set_control_line and equals to CTRL priority, but
    in setup phase it should be SETUP. This does not break things
    but seems inconsistent.
    
    Rename functions to conforming names.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 5bffd75747fe425d5825e347c48d116d525e8c24
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Aug 22 16:50:56 2007 +0200

    ipwireless_cs: Merge dump of data bytes
    
    Merge code which dumps data bytes in fragment send an recv.
    Show setup state in hardware dump output.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit e1ddb69d5b35c00c7b7dd6105db334df40afb61d
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 21 09:10:43 2007 +0200

    ipwireless_cs: Use is_card_present
    
    Use is_card_present in interrupt handlers.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 58fedd31e1d586330f71f009ef735fd0a7fa03e4
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 21 09:10:37 2007 +0200

    ipwireless_cs: Remove packet assembler structs
    
    Remove packet assembler struct, it only hides pointer indirection.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 649080b63b65456b4a81e41db3a2f2f920b42dc3
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 21 09:10:32 2007 +0200

    ipwireless_cs: Remove one pointless goto
    
    Remove one pointless goto.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit a815b7a8cfc165b325a3466e33cd133bc0f17530
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 21 09:10:27 2007 +0200

    ipwireless_cs: Save irq flags with spinlock
    
    Save irq flags with spinlock in recv workqueue handler.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 140f4a2f60a19c15a3183545f393f26ab73d7b3a
Author: David Sterba <dsterba@suse.cz>
Date:   Tue Aug 21 09:10:22 2007 +0200

    ipwireless_cs: Misc cleanups
    
    Misc cleanups and trivial changes:
    * rename do_io
    * remove redundant comments from obvious code
    * more explanatory comments
    * remove duplicite variables
    * minor code cleanups
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 5027ffb7f9d03f9a7f67633bdc008549fac0e3f8
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Aug 20 17:07:45 2007 +0200

    ipwireless_cs: Split do_io callsites into send or recv part
    
    Split do_io callsites into send or recv part and don't call do_io.
    Remove recursion protection, not possible anymore.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 7ab6ddf645b2b71d809bbe89e3d250d5efd69f22
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Aug 20 17:07:39 2007 +0200

    ipwireless_cs: Send: get maximum send priority via parameter
    
    Send: get maximum send priority via parameter. Callsite knows the priority.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit d14d675f93e190646648d88462eab4cea2a57b22
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Aug 20 17:07:34 2007 +0200

    ipwireless_cs: Put send code into own function
    
    Put send code of do_io to own function. Kill the demonic while
    loop and let send func return if more is to be sent.
    Setup code is left there.
    
    It is needed to call both send and receive, else packets will stay
    unsent.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit a588d7f7637e925c8054702db917684d8e9254ef
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Aug 20 17:07:29 2007 +0200

    ipwireless_cs: Put recving into func
    
    Put do_io recving code into own function.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 891ce4e469e4cf1971ee30a015222e4e5b2093df
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Aug 20 17:07:24 2007 +0200

    ipwireless_cs: Split do_io() send and receive
    
    Split send and receive functionality inside do_io.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 876767a5a411483a34c3f18289cc928c237426e2
Author: David Sterba <dsterba@suse.cz>
Date:   Thu Aug 9 13:37:27 2007 +0200

    ipwireless_cs: Use memset
    
    Use memset instead of zeroing loop.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit e29f12897359edf232422dbcdb1b391cf6c5cf18
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Aug 9 13:37:13 2007 +0200

    ipwireless_cs: Cleanups spotted by checkpatch.pl
    
    As suggested by checkpatch.pl
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 972d36494bda5db82ea269ff22a349af6a486cf9
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Jul 12 17:04:31 2007 +0200

    Revert "ipwireless_cs: Network code refactoring"
    
    This reverts commit 19076b803e12ad37af19e8dd3a738891f0462cb5.

commit c31465b216e67441fc9efbff18280351e8ad293e
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Jul 12 17:04:14 2007 +0200

    Revert "ipwireless_cs: Use is_ppp_blocked"
    
    This reverts commit 809098ed9786838ffc2d126af8d36551917de0c0.

commit 65e4bb02f6535f486ff6600201637cad52a9f061
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Jun 28 00:09:29 2007 +0200

    ipwireless_cs: Fix whitespace damage
    
    Remove trailing whitespace.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 16c1c7a98feb707318e6dee2e6b60c0d95578c80
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Jun 18 16:29:12 2007 +0200

    ipwireless_cs: Minor cleanup: merge hw interrupt ack
    
    Merge pcmcia interrupt acknowledgement calls.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 5329d2a273eb2a51cfcbaed4e2d15d9bf67414bb
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 15 13:59:22 2007 +0200

    ipwireless_cs: Move tasklet scheduling to own func
    
    Merge tasklet scheduling code to func from all callsites.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 949f73144c302805257bf69368beff8d19872ed6
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 15 13:59:17 2007 +0200

    ipwireless_cs: Rename initializing funcs
    
    Rename initializing funcs to match versioning naming scheme, update
    callers.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit ceee838717c27bf727a2baa63ff86e8dc917e62e
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 15 13:59:12 2007 +0200

    ipwireless_cs: Remove unnecessary prototypes
    
    Remove unnecessary prototypes for static functions.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 809098ed9786838ffc2d126af8d36551917de0c0
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Jun 6 15:03:28 2007 +0200

    ipwireless_cs: Use is_ppp_blocked
    
    Forgotten usage of is_ppp_blocked after previous refactoring
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 7f7e3ce3c6d49611087e422bb90c847f4d83b783
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Jun 6 11:59:18 2007 +0200

    ipwireless_cs: Uncamelize variables in hw
    
    Rename variables from camel notation. Pick better name when possible.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 051ee1e9cc1fd869b6804a2dc10e7fa51a5342a2
Author: David Sterba <dsterba@suse.cz>
Date:   Mon Jun 4 17:09:31 2007 +0200

    ipwireless_cs: Whitespace and codingstyle cleanups in hw
    
    Reformat acc to CodingStyle
    - long comments
    - func prototypes
    - delcarations
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit c8646283efcf9b9cbde523978eaf1eada7709445
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 1 17:12:13 2007 +0200

    ipwireless_cs: Minor clenups in network code
    
    (non intrusive changes)
    
    - use C99 struct intializeres
    - group defines together
    - func prototype formatting
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 2ffa059b04d460f8ec3ca3396c2d1327494826d4
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 1 12:17:13 2007 +0200

    ipwireless_cs: Fix sparse warning: different address space
    
    Fix warnings like
    
    drivers/char/pcmcia/ipwireless_cs_network.c:179:7: warning: incorrect type
    in argument 1 (different address spaces)
    drivers/char/pcmcia/ipwireless_cs_network.c:179:7:    expected void
    [noderef] *<noident><asn:1>
    drivers/char/pcmcia/ipwireless_cs_network.c:179:7:    got int *<noident>
    
    and use __user tag for get_user/put_user.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit f9f36294c0c198d0de3311ad718b0f294c296f01
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 1 12:17:11 2007 +0200

    ipwireless_cs: Fix sparse warnings: different address spaces
    
    Fix warnings like
    drivers/char/pcmcia/ipwireless_cs_hardware.c:1067:36: warning: incorrect
    type in argument 1 (different address spaces)
    drivers/char/pcmcia/ipwireless_cs_hardware.c:1067:36:    expected void
    [noderef] *<noident><asn:2>
    drivers/char/pcmcia/ipwireless_cs_hardware.c:1067:36:    got unsigned short
    *MemTX
    
    when using mmapped io
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit b9411cc109ae121c937de0eb19b22d211cc57629
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 1 12:11:32 2007 +0200

    ipwireless_cs: Remove callback typedefs
    
    Remove all callback typedefs and use the type inline.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 19076b803e12ad37af19e8dd3a738891f0462cb5
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 1 12:11:30 2007 +0200

    ipwireless_cs: Network code refactoring
    
    Refactor ppp_blocked, substitue variable by function, adjust packet-sent
    notifier.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 18faa2c9f0f31b1236f4275de1a9a853155a71dd
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jun 1 12:11:28 2007 +0200

    ipwireless_cs: Remove macro hiding __iomem
    
    Remove macro hiding __iomem, use it directly.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 282abf6f45261bf663b450838d60885fccf8024d
Author: David Sterba <dsterba@suse.cz>
Date:   Thu May 24 10:58:31 2007 +0200

    ipwireless_cs: Cleanup timig stats
    
    Group timing statistic together. Remove ifdefs.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit b5a2470e0cbd017525d9ca356d57c4b3eb9752e8
Author: David Sterba <dsterba@suse.cz>
Date:   Wed May 23 09:41:51 2007 +0200

    ipwireless_cs: Convert binary semaphore to mutex
    
    Convert tty binary semaphore to mutex.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 944bfe5449dc0cadb8c222d20ec0f819c1dc8703
Author: David Sterba <dsterba@suse.cz>
Date:   Tue May 22 13:47:48 2007 +0200

    ipwireless_cs: code clenaups - spinlocks
    
    Convert trivial cases of spin_{un}lock to use flag-preserving versions.
    Use long for the flags.
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 51e3c96d32a67497666b3caafa85b6faac7dd2c4
Author: David Sterba <dsterba@suse.cz>
Date:   Tue May 22 11:52:32 2007 +0200

    ipwireless_cs: more code cleanups
    
    codingstyle cleanups:
    - long lines
    - prototype argument names
    - CodingStyle
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit b62dc6a70ad11f4f60274af7b1cb1567489c8191
Author: David Sterba <dsterba@suse.cz>
Date:   Mon May 21 12:29:19 2007 +0200

    ipwireless_cs: type/whitespace cleanups
    
    - rename u_char/u_short/u_long/u_int types
    - struct typedef renamed and struct used
    - minor whitespace changes
    
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit d33b119cb1bdf6c6b869c43901fbd734ba5ddf38
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Wed Mar 21 19:21:39 2007 -0700

    ipwireless_cs: use ANSI function declaration
    
    Fix function declaration:
    drivers/char/pcmcia/ipwireless_cs_tty.c:730:29: warning: non-ANSI function declaration of function 'ipwireless_tty_release'
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 25a81464c6c9daf8208f85bcb53e60fffd67c4e3
Author: Michal Rokos <michal.rokos@gmail.com>
Date:   Thu Mar 22 10:40:42 2007 +0100

    ipwireless_cs: enable autoload of module
    
    This makes kernel to load ipwireless_cs module when card is inserted.
    
    Signed-off-by: Michal Rokos <michal.rokos@gmail.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit dc8dbb79a4bd215b20f045ec019b6c637045fd31
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Mar 14 15:16:17 2007 +0100

    ipwireless_cs: Remove ipw_hardware_t.in_process_context_loop
    
    Conditional workqueue scheduling is absolutely unnecessary and
    might be racy. Remove it.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit e0d380b5b0cbddab13d1a76a5d99e875cbd28413
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Mar 14 14:02:42 2007 +0100

    ipwireless_cs: update driver version
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 4976021a4f5c07fb53cff7f50327725146d055ec
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Mar 14 13:38:21 2007 +0100

    Revert "ipwireless_cs: make RAS the default channel"
    
    This reverts commit d5cbcf3c66d72e5fd8a68dbcd6e148e4abb15ed1.
    
    This commit might cause oops due to NULL tty in ipwireless_tty_received()
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 214e011e47787c11101e736f00381690eca19aa8
Author: Stephen Blackheath <stephen@blacksapphire.com>
Date:   Wed Mar 14 13:36:32 2007 +0100

    ipwireless_cs: queue ctrl packets along with data packets
    
    This patch ensures that the CTRL events are queued along with the DATA events
    so they are guaranteed to be processed in the correct sequence. This fixes a bug
    of non-deterministic processing of CTRL and DATA packets in interleaved (and bad)
    order.
    
    Signed-off-by: Stephen Blackheath <stephen@blacksapphire.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 8afbb76752b7be2b13fd7d452abd894d7a16c81e
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Feb 7 23:27:46 2007 +0100

    ipwireless_cs: remove debugging output
    
    The debugging output is no more needed, stripping the packet
    header works well.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 2b795ff9e4325443aa8a0b67fe7acf63cbb46f51
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Feb 7 17:10:07 2007 +0100

    ipwireless_cs: Fix 'unsupported protocol ff03' from pppd
    
    Some versions of firmware stuff packets with 0xff 0x03 bytes (which
    are required on sent packet, but not always present on received
    packets). Detect such situation and skip the offending bytes.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3b28985ff1356dcd4d0d3e7812b90e2661caf37f
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Feb 1 13:40:36 2007 +0100

    ipwireless_cs: convert close_lock to mutex
    
    Convert close_lock from semaphore to mutex.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 8105a5aacbd08d907923743966d4b4c30bf6a04d
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Feb 1 11:58:46 2007 +0100

    ipwireless_cs: don't cast ppp_channel.private
    
    ppp_channel.private is already void* and therefore shouldn't be cast.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit c7b00d4edd0c8b885bc547c4ec6cb24907ea5a25
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Feb 1 11:50:48 2007 +0100

    ipwireless_cs: fix comments
    
    Remove some overcommenting.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit f7a057c39baca1523c324a0396b442731faa0d9a
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Feb 1 11:22:57 2007 +0100

    ipwireless_cs: don't zero-initialize static vars
    
    Remove zero-initialization of static variables.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 385b2f81f451184fbd9d3b0875653d6150c70d3d
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Feb 1 11:19:58 2007 +0100

    ipwireless_cs: change return value of create_packet() to void*
    
    create_packet() is used to create various types of packets. So let
    it return void* and avoid casting on all callsites.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 13b489baff531dd59520502966b4855291ed44b0
Author: Adrian Bunk <bunk@stusta.de>
Date:   Tue Jan 30 14:37:36 2007 +0100

    drivers/char/pcmcia/ipwireless_cs_*: cleanups
    
    - proper prototypes for global functions in header files
    - make the following needlessly global function static:
      - ipwireless_cs_hardware.c: data_type()
    - make the following needlessly global struct static:
      - ipwireless_cs_tty.c: ipw_tty_driver
    - #if 0 the following unused global functions:
      - ipwireless_cs_hardware.c: ipwireless_get_config()
      - ipwireless_cs_tty.c: ipw_flush_buffer()
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit bc200ccbf5153067f30ec7a306770c186e84932b
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Mon Jan 29 16:15:16 2007 +0100

    ipwireless_cs: fix some kmalloc-related coding style isssues
    
    - removed casts of kmalloc retval
    - kmalloc+memeset -> kzalloc
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit daf86d0c8add3b7b734db82af3b465f4fda2bc84
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Tue Jan 23 13:12:09 2007 +0100

    ipwireless_cs: Fix stack overflow in debug mode (no. 2)
    
    when ipwireless_cs_debug == 1, there is a stack overflow
    in do_receive_packet(). Fix it by allocating proper space
    for every byte in the packet.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 0860433c8a046a89bece88a9af8c9122fb568217
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Mon Jan 22 15:36:33 2007 +0100

    ipwireless_cs: Fix stack overflow in debug mode
    
    when ipwireless_cs_debug == 1, there is a stack overflow
    in do_send_fragment(). Fix it by allocating proper space
    for every byte in the packet fragment.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 9e8db899c78da28dbb252f282b01cfedcc120c5b
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Mon Jan 22 15:24:01 2007 +0100

    ipwireless_cs: significant code cleanups
    
    - interrupt handling splitted into multiple functions
    - handling of setup packet cleaned up and splitted to be readable
    - more CodingStyle work
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 188b1182866c84ed387eb94b438cddbf363d842a
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Mon Jan 22 11:51:45 2007 +0100

    ipwireless_cs: convert the driver to use in-kernel linked lists
    
    Move away from own implementation of linked list in favor of list.h
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 80bf42eccb04f7ce6d3dceb9084bfac24dbdde8c
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Jan 18 14:49:15 2007 +0100

    ipwireless_cs: small code cleanups
    
    Fixed //-style comments, unified conditions that belong
    together
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit b61a07a813491f4f936b878d2aa71f226ddc480d
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Thu Jan 18 11:07:40 2007 +0100

    ipwireless_cs: make RAS the default channel
    
    RAS could be used completely instead of DIALLER channel. This
    also makes secondary channel unneeded.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 4b317e8409803a5e7a9a7aded56cdd7a9aa2441e
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Mon Jan 15 15:09:11 2007 +0100

    ipwireless_cs: make the V3 card ppp connections work
    
    V3 card requires the dial commands to be sent on RAS channel and
    not DIAL channel - when being sent on DIAL channel, the PPP framer
    on the card is not configured properly.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 3b1e6f0685f6f752adb42ffd1a83421c64516f73
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Fri Jan 12 16:18:18 2007 +0100

    ipwireless-cs: some code cleanup
    
    The code doesn't comply with CodingStyle too much. Push
    it a bit in the right direction.
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

commit 40f584f6802a5438df158d24b9c545a9ce7680ac
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Fri Jan 12 13:31:50 2007 +0100

    ipwireless_cs: initial code merge into the tree
    
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                                        |    8 
 drivers/char/pcmcia/Kconfig                        |    8 
 drivers/char/pcmcia/Makefile                       |    4 
 drivers/char/pcmcia/ipwireless_cs_hardware.c       | 1746 +++++++++++
 drivers/char/pcmcia/ipwireless_cs_hardware.h       |   64 
 drivers/char/pcmcia/ipwireless_cs_main.c           |  482 +++
 drivers/char/pcmcia/ipwireless_cs_main.h           |   75 
 drivers/char/pcmcia/ipwireless_cs_network.c        |  498 +++
 drivers/char/pcmcia/ipwireless_cs_network.h        |   54 
 drivers/char/pcmcia/ipwireless_cs_setup_protocol.h |  108 
 drivers/char/pcmcia/ipwireless_cs_tty.c            |  786 ++++
 drivers/char/pcmcia/ipwireless_cs_tty.h            |   48 
 12 files changed, 3881 insertions(+)

diff -puN MAINTAINERS~git-ipwireless_cs MAINTAINERS
--- a/MAINTAINERS~git-ipwireless_cs
+++ a/MAINTAINERS
@@ -2126,6 +2126,14 @@ M:	acme@ghostprotocols.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+IPWIRELESS_CS DRIVER
+P:	Jiri Kosina
+M:	jkosina@suse.cz
+P:	David Sterba
+M:	dsterba@suse.cz
+S:	Maintained
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
+
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
 M:	samuel@sortiz.org
diff -puN drivers/char/pcmcia/Kconfig~git-ipwireless_cs drivers/char/pcmcia/Kconfig
--- a/drivers/char/pcmcia/Kconfig~git-ipwireless_cs
+++ a/drivers/char/pcmcia/Kconfig
@@ -42,6 +42,14 @@ config CARDMAN_4040
 	  PC/SC ifdhandler provided from the Omnikey homepage
 	  (http://www.omnikey.com/), or a current development version of OpenCT
 	  (http://www.opensc.org/).
+config IPWIRELESS_CS
+	tristate "IPWireless 3G UMTS PCMCIA card support"
+	depends on PCMCIA
+	select PPP
+	help
+	  This is a driver for 3G UMTS PCMCIA card from IPWireless company. In
+	  some countries (for example Czech Republic, T-Mobile ISP) this card
+	  is shipped for service called UMTS 4G.
 
 endmenu
 
diff -puN drivers/char/pcmcia/Makefile~git-ipwireless_cs drivers/char/pcmcia/Makefile
--- a/drivers/char/pcmcia/Makefile~git-ipwireless_cs
+++ a/drivers/char/pcmcia/Makefile
@@ -4,6 +4,10 @@
 # Makefile for the Linux PCMCIA char device drivers.
 #
 
+ipwireless_cs-objs	:= ipwireless_cs_hardware.o ipwireless_cs_main.o ipwireless_cs_network.o ipwireless_cs_tty.o
+
 obj-$(CONFIG_SYNCLINK_CS) += synclink_cs.o
 obj-$(CONFIG_CARDMAN_4000) += cm4000_cs.o
 obj-$(CONFIG_CARDMAN_4040) += cm4040_cs.o
+obj-$(CONFIG_IPWIRELESS_CS) += ipwireless_cs.o
+
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_hardware.c
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_hardware.c
@@ -0,0 +1,1746 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+
+#include "ipwireless_cs_hardware.h"
+#include "ipwireless_cs_setup_protocol.h"
+#include "ipwireless_cs_network.h"
+#include "ipwireless_cs_main.h"
+
+/* Function prototypes */
+static void ipw_send_setup_packet(struct ipw_hardware *hw);
+static void handle_received_SETUP_packet(struct ipw_hardware *ipw,
+					 unsigned int address,
+					 unsigned char *data, int len,
+					 int is_last);
+static void ipwireless_setup_timer(unsigned long data);
+static void handle_received_CTRL_packet(struct ipw_hardware *hw,
+		unsigned int channel_idx, unsigned char *data, int len);
+
+/*#define TIMING_DIAGNOSTICS*/
+
+#ifdef TIMING_DIAGNOSTICS
+
+static struct timing_stats {
+	unsigned long last_report_time;
+	unsigned long read_time;
+	unsigned long write_time;
+	unsigned long read_bytes;
+	unsigned long write_bytes;
+	unsigned long start_time;
+};
+
+static void start_timing(void)
+{
+	timing_stats.start_time = jiffies;
+}
+
+static void end_read_timing(unsigned length)
+{
+	timing_stats.read_time += (jiffies - start_time);
+	timing_stats.read_bytes += length + 2;
+	report_timing();
+}
+
+static void end_write_timing(unsigned length)
+{
+	timing_stats.write_time += (jiffies - start_time);
+	timing_stats.write_bytes += length + 2;
+	report_timing();
+}
+
+static void report_timing(void)
+{
+	unsigned long since = jiffies - timing_stats.last_report_time;
+
+	/* If it's been more than one second... */
+	if (since >= HZ) {
+		int first = (timing_stats.last_report_time == 0);
+
+		timing_stats.last_report_time = jiffies;
+		if (!first)
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": %u us elapsed - read %lu bytes in %u us, "
+			       "wrote %lu bytes in %u us\n",
+			       jiffies_to_usecs(since),
+			       timing_stats.read_bytes,
+			       jiffies_to_usecs(timing_stats.read_time),
+			       timing_stats.write_bytes,
+			       jiffies_to_usecs(timing_stats.write_time));
+
+		timing_stats.read_time = 0;
+		timing_stats.write_time = 0;
+		timing_stats.read_bytes = 0;
+		timing_stats.write_bytes = 0;
+	}
+}
+#else
+static void start_timing(void) { }
+static void end_read_timing(unsigned length) { }
+static void end_write_timing(unsigned length) { }
+#endif
+
+/* Imported IPW definitions */
+
+#define LL_MTU_V1 318
+#define LL_MTU_V2 250
+#define LL_MTU_MAX (LL_MTU_V1 > LL_MTU_V2 ? LL_MTU_V1 : LL_MTU_V2)
+
+#define PRIO_DATA  2
+#define PRIO_CTRL  1
+#define PRIO_SETUP 0
+
+/* Addresses */
+#define ADDR_SETUP_PROT 0
+
+/* Protocol ids */
+enum {
+	/* Identifier for the Com Data protocol */
+	TL_PROTOCOLID_COM_DATA = 0,
+
+	/* Identifier for the Com Control protocol */
+	TL_PROTOCOLID_COM_CTRL = 1,
+
+	/* Identifier for the Setup protocol */
+	TL_PROTOCOLID_SETUP = 2
+};
+
+/* Number of bytes in NL packet header (can not do
+ * sizeof(nl_packet_header) since it's a bitfield) */
+#define NL_FIRST_PACKET_HEADER_SIZE        3
+
+/* Number of bytes in NL packet header (can not do
+ * sizeof(nl_packet_header) since it's a bitfield) */
+#define NL_FOLLOWING_PACKET_HEADER_SIZE    1
+
+struct nl_first_paket_header {
+#if defined(__BIG_ENDIAN)
+	unsigned char packet_rank:2;
+	unsigned char address:3;
+	unsigned char protocol:3;
+#else
+	unsigned char protocol:3;
+	unsigned char address:3;
+	unsigned char packet_rank:2;
+#endif
+	unsigned char length_lsb;
+	unsigned char length_msb;
+};
+
+struct nl_packet_header {
+#if defined(__BIG_ENDIAN)
+	unsigned char packet_rank:2;
+	unsigned char address:3;
+	unsigned char protocol:3;
+#else
+	unsigned char protocol:3;
+	unsigned char address:3;
+	unsigned char packet_rank:2;
+#endif
+};
+
+/* Value of 'packet_rank' above */
+#define NL_INTERMEDIATE_PACKET    0x0
+#define NL_LAST_PACKET            0x1
+#define NL_FIRST_PACKET           0x2
+
+union nl_packet {
+	/* Network packet header of the first packet (a special case) */
+	struct nl_first_paket_header hdr_first;
+	/* Network packet header of the following packets (if any) */
+	struct nl_packet_header hdr;
+	/* Complete network packet (header + data) */
+	unsigned char rawpkt[LL_MTU_MAX];
+} __attribute__ ((__packed__));
+
+#define HW_VERSION_UNKNOWN -1
+#define HW_VERSION_1 1
+#define HW_VERSION_2 2
+
+/* IPW I/O ports */
+#define IOIER 0x00		/* Interrupt Enable Register */
+#define IOIR  0x02		/* Interrupt Source/ACK register */
+#define IODCR 0x04		/* Data Control Register */
+#define IODRR 0x06		/* Data Read Register */
+#define IODWR 0x08		/* Data Write Register */
+#define IOESR 0x0A		/* Embedded Driver Status Register */
+#define IORXR 0x0C		/* Rx Fifo Register (Host to Embedded) */
+#define IOTXR 0x0E		/* Tx Fifo Register (Embedded to Host) */
+
+/* I/O ports and bit definitions for version 1 of the hardware */
+
+/* IER bits*/
+#define IER_RXENABLED   ((unsigned short) 0x1)
+#define IER_TXENABLED   ((unsigned short) 0x2)
+
+/* ISR bits */
+#define IR_RXINTR       ((unsigned short) 0x1)
+#define IR_TXINTR       ((unsigned short) 0x2)
+
+/* DCR bits */
+#define DCR_RXDONE      ((unsigned short) 0x1)
+#define DCR_TXDONE      ((unsigned short) 0x2)
+#define DCR_RXRESET     ((unsigned short) 0x4)
+#define DCR_TXRESET     ((unsigned short) 0x8)
+
+/* I/O ports and bit definitions for version 2 of the hardware */
+
+struct MEMCCR {
+	unsigned short PCCOR;		/* Configuration Option Register */
+	unsigned short PCCSR;		/* Configuration and Status Register */
+	unsigned short PCPRR;		/* Pin Replacemant Register */
+	unsigned short PCSCR;		/* Socket and Copy Register */
+	unsigned short PCESR;		/* Extendend Status Register */
+	unsigned short PCIOB;		/* I/O Base Register */
+};
+
+struct MEMINFREG {
+	unsigned short memreg_tx_old;	/* TX Register (R/W) */
+	unsigned short pad1;
+	unsigned short memreg_rx_done;	/* RXDone Register (R/W) */
+	unsigned short pad2;
+	unsigned short memreg_rx;	/* RX Register (R/W) */
+	unsigned short pad3;
+	unsigned short memreg_pc_interrupt_ack;	/* PC intr Ack Register (W) */
+	unsigned short pad4;
+	unsigned long memreg_card_present;/* Mask for Host to check (R) for
+					   * CARD_PRESENT_VALUE */
+	unsigned short memreg_tx_new;	/* TX2 (new) Register (R/W) */
+};
+
+#define IODMADPR 0x00		/* DMA Data Port Register (R/W) */
+
+#define CARD_PRESENT_VALUE ((unsigned long)0xBEEFCAFEUL)
+
+#define MEMTX_TX                       0x0001
+#define MEMRX_RX                       0x0001
+#define MEMRX_RX_DONE                  0x0001
+#define MEMRX_PCINTACKK                0x0001
+#define MEMRX_MEMSPURIOUSINT           0x0001
+
+#define NL_NUM_OF_PRIORITIES       3
+#define NL_NUM_OF_PROTOCOLS        3
+#define NL_NUM_OF_ADDRESSES        NO_OF_IPW_CHANNELS
+
+struct ipw_hardware {
+	unsigned int base_port;
+	short hw_version;
+	unsigned short ll_mtu;
+	struct ipw_config config;
+	spinlock_t spinlock;
+
+	int initializing;
+	int init_loops;
+	struct timer_list setup_timer;
+
+	int tx_ready;
+	struct list_head tx_queue[NL_NUM_OF_PRIORITIES];
+	/* True if any packets are queued for transmission */
+	int tx_queued;
+
+	int rx_bytes_queued;
+	struct list_head rx_queue;
+	/* Pool of rx_packet structures that are not currently used. */
+	struct list_head rx_pool;
+	/* True if reception of data is blocked while userspace processes it. */
+	int blocking_rx;
+	/* True if there is RX data ready on the hardware. */
+	int rx_ready;
+	unsigned short last_memtx_serial;
+	/*
+	 * Newer versions of the V2 card firmware send serial numbers in the
+	 * MemTX register. 'serial_number_detected' is set true when we detect
+	 * a non-zero serial number (indicating the new firmware).  Thereafter,
+	 * the driver can safely ignore the Timer Recovery re-sends to avoid
+	 * out-of-sync problems.
+	 */
+	int serial_number_detected;
+	struct work_struct work_rx;
+
+	/* True if we are to send the set-up data to the hardware. */
+	int to_setup;
+
+	/* Card has been removed */
+	int removed;
+	/* Saved irq value when we disable the interrupt. */
+	int irq;
+	/* True if this driver is shutting down. */
+	int shutting_down;
+	/* Modem control lines */
+	unsigned int control_lines[NL_NUM_OF_ADDRESSES];
+	struct ipw_rx_packet *packet_assembler[NL_NUM_OF_ADDRESSES];
+
+	struct tasklet_struct tasklet;
+
+	/* The handle for the network layer, for the sending of events to it. */
+	struct ipw_network *network;
+	struct MEMINFREG __iomem *memory_info_regs;
+	struct MEMCCR __iomem *memregs_CCR;
+	int bad_interrupt_count;
+	void (*reboot_callback) (void *data);
+	void *reboot_callback_data;
+
+	unsigned short __iomem *memreg_tx;
+};
+
+/*
+ * Packet info structure for tx packets.
+ * Note: not all the fields defined here are required for all protocols
+ */
+struct ipw_tx_packet {
+	struct list_head queue;
+	/* channel idx + 1 */
+	unsigned char dest_addr;
+	/* SETUP, CTRL or DATA */
+	unsigned char protocol;
+	/* Length of data block, which starts at the end of this structure */
+	unsigned short length;
+	/* Function to call upon packet completion. */
+	void (*packet_sent_callback) (struct ipw_tx_packet *packet);
+	/* Sending state */
+	/* Offset of where we've sent up to so far */
+	unsigned long offset;
+	/* Count of packet fragments, starting at 0 */
+	int fragment_count;
+
+	void (*external_callback) (void *cb, unsigned int length);
+	void *external_callback_data;
+};
+
+/* Signals from DTE */
+enum ComCtrl_DTESignal {
+	ComCtrl_RTS = 0,
+	ComCtrl_DTR = 1
+};
+
+/* Signals from DCE */
+enum ComCtrl_DCESignal {
+	ComCtrl_CTS = 2,
+	ComCtrl_DCD = 3,
+	ComCtrl_DSR = 4,
+	ComCtrl_RI = 5
+};
+
+struct ipw_control_packet_body {
+	/* ComCtrl_DTESignal or ComCtrl_DCESignal */
+	unsigned char sig_no;
+	/* ComCtrl_SET(0) or ComCtrl_CLEAR(1) */
+	unsigned char value;
+} __attribute__ ((__packed__));
+
+struct ipw_control_packet {
+	struct ipw_tx_packet packet;
+	struct ipw_control_packet_body body;
+};
+
+struct ipw_rx_packet {
+	struct list_head queue;
+	unsigned int capacity;
+	unsigned int length;
+	unsigned int protocol;
+	unsigned int channel_idx;
+};
+
+#ifdef IPWIRELESS_STATE_DEBUG
+int ipwireless_dump_hardware_state(char *p, struct ipw_hardware *hw)
+{
+	int idx = 0;
+
+	idx += sprintf(p + idx, "debug: initializing=%d\n", hw->initializing);
+	idx += sprintf(p + idx, "debug: tx_ready=%d\n", hw->tx_ready);
+	idx += sprintf(p + idx, "debug: tx_queued=%d\n", hw->tx_queued);
+	idx += sprintf(p + idx, "debug: rx_ready=%d\n", hw->rx_ready);
+	idx += sprintf(p + idx, "debug: rx_bytes_queued=%d\n",
+			hw->rx_bytes_queued);
+	idx += sprintf(p + idx, "debug: blocking_rx=%d\n", hw->blocking_rx);
+	idx += sprintf(p + idx, "debug: removed=%d\n", hw->removed);
+	idx += sprintf(p + idx, "debug: hardware.shutting_down=%d\n",
+			hw->shutting_down);
+	idx += sprintf(p + idx, "debug: to_setup=%d\n",
+			hw->to_setup);
+	return idx;
+}
+#endif
+
+static char *data_type(const unsigned char *buf, unsigned length)
+{
+	struct nl_packet_header *hdr = (struct nl_packet_header *) buf;
+
+	if (length == 0)
+		return "     ";
+
+	if (hdr->packet_rank & NL_FIRST_PACKET) {
+		switch (hdr->protocol) {
+		case TL_PROTOCOLID_COM_DATA:	return "DATA ";
+		case TL_PROTOCOLID_COM_CTRL:	return "CTRL ";
+		case TL_PROTOCOLID_SETUP:	return "SETUP";
+		default: return "???? ";
+		}
+	} else
+		return "     ";
+}
+
+#define DUMP_MAX_BYTES 64
+
+static void dump_data_bytes(const char *prefix, const unsigned char *data,
+			    unsigned length)
+{
+	int i;
+	char buf[DUMP_MAX_BYTES * 4 + 16];
+
+	buf[0] = 0;
+	for (i = 0; i < length && i < DUMP_MAX_BYTES; i++)
+		sprintf(buf + strlen(buf), " %02x", (unsigned int) data[i]);
+	if (i > DUMP_MAX_BYTES)
+		strcat(buf, " ...");
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME ": %s fragment %s %s\n",
+			prefix, data_type(data, length), buf);
+}
+
+static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
+			    unsigned length)
+{
+	int i;
+	unsigned long flags;
+
+	start_timing();
+
+	if (length == 0)
+		return 0;
+
+	if (length > hw->ll_mtu)
+		return -1;
+
+	if (ipwireless_cs_debug)
+		dump_data_bytes("send", data, length);
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+
+	if (hw->hw_version == HW_VERSION_1) {
+		outw((unsigned short) length, hw->base_port + IODWR);
+
+		for (i = 0; i < length; i += 2) {
+			unsigned short d = data[i];
+			__le16 raw_data;
+
+			if (likely(i + 1 < length))
+				d |= data[i + 1] << 8;
+			raw_data = cpu_to_le16(d);
+			outw(raw_data, hw->base_port + IODWR);
+		}
+
+		outw(DCR_TXDONE, hw->base_port + IODCR);
+	} else if (hw->hw_version == HW_VERSION_2) {
+		outw((unsigned short) length, hw->base_port + IODMADPR);
+
+		for (i = 0; i < length; i += 2) {
+			unsigned short d = data[i];
+			__le16 raw_data;
+
+			if ((i + 1 < length))
+				d |= data[i + 1] << 8;
+			raw_data = cpu_to_le16(d);
+			outw(raw_data, hw->base_port + IODMADPR);
+		}
+		while ((i & 3) != 2) {
+			outw((unsigned short) 0xDEAD, hw->base_port + IODMADPR);
+			i += 2;
+		}
+		iowrite16(MEMRX_RX, &hw->memory_info_regs->memreg_rx);
+	}
+
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	end_write_timing(length);
+
+	return 0;
+}
+
+static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
+{
+	unsigned short fragment_data_len;
+	unsigned short data_left = packet->length - packet->offset;
+	unsigned short header_size;
+	union nl_packet pkt;
+
+	header_size =
+	    (packet->fragment_count == 0)
+	    ? NL_FIRST_PACKET_HEADER_SIZE
+	    : NL_FOLLOWING_PACKET_HEADER_SIZE;
+	fragment_data_len = (unsigned short) hw->ll_mtu - header_size;
+	if (data_left < fragment_data_len)
+		fragment_data_len = data_left;
+
+	pkt.hdr_first.protocol = packet->protocol;
+	pkt.hdr_first.address = packet->dest_addr;
+	pkt.hdr_first.packet_rank = 0;
+
+	/* First packet? */
+	if (packet->fragment_count == 0) {
+		pkt.hdr_first.packet_rank |= NL_FIRST_PACKET;
+		pkt.hdr_first.length_lsb = (unsigned char) packet->length;
+		pkt.hdr_first.length_msb =
+			(unsigned char) (packet->length >> 8);
+	}
+
+	memcpy(pkt.rawpkt + header_size,
+	       ((unsigned char *) packet) + sizeof(struct ipw_tx_packet) +
+	       packet->offset, fragment_data_len);
+	packet->offset += fragment_data_len;
+	packet->fragment_count++;
+
+	/* Last packet? (May also be first packet.) */
+	if (packet->offset == packet->length)
+		pkt.hdr_first.packet_rank |= NL_LAST_PACKET;
+	do_send_fragment(hw, pkt.rawpkt, header_size + fragment_data_len);
+
+	/* If this packet has unsent data, then re-queue it. */
+	if (packet->offset < packet->length) {
+		/*
+		 * Re-queue it at the head of the highest priority queue so
+		 * it goes before all other packets
+		 */
+		unsigned long flags;
+
+		spin_lock_irqsave(&hw->spinlock, flags);
+		list_add(&packet->queue, &hw->tx_queue[0]);
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+	} else
+		packet->packet_sent_callback(packet);
+
+	return 0;
+}
+
+static void free_packet(struct ipw_tx_packet *packet)
+{
+       kfree(packet);
+}
+
+static void free_packet_and_callback(struct ipw_tx_packet *packet)
+{
+	if (packet->external_callback)
+		packet->external_callback(packet->external_callback_data,
+					  packet->length);
+
+	kfree(packet);
+}
+
+static void ipw_setup_hardware(struct ipw_hardware *hw)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	if (hw->hw_version == HW_VERSION_1) {
+		/* Reset RX FIFO */
+		outw(DCR_RXRESET, hw->base_port + IODCR);
+		/* SB: Reset TX FIFO */
+		outw(DCR_TXRESET, hw->base_port + IODCR);
+
+		/* Enable TX and RX interrupts. */
+		outw(IER_TXENABLED | IER_RXENABLED, hw->base_port + IOIER);
+	} else {
+		/*
+		 * Set INTRACK bit (bit 0), which means we must explicitly
+		 * acknowledge interrupts by clearing bit 2 of PCCSR.
+		 */
+		unsigned short csr = ioread16(&hw->memregs_CCR->PCCSR);
+
+		csr |= 1;
+		iowrite16(csr, &hw->memregs_CCR->PCCSR);
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+}
+
+/*
+ * If 'packet' is NULL, then this function allocates a new packet, setting its
+ * length to 0 and ensuring it has the specified minimum amount of free space.
+ *
+ * If 'packet' is not NULL, then this function enlarges it if it doesn't
+ * have the specified minimum amount of free space.
+ *
+ */
+static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
+					   struct ipw_rx_packet *packet,
+					   int minimum_free_space)
+{
+
+	if (!packet) {
+		unsigned long flags;
+
+		/*
+		 * If this is the first fragment, then we will need to fetch a
+		 * packet to put it in.
+		 */
+		spin_lock_irqsave(&hw->spinlock, flags);
+		/* If we have one in our pool, then pull it out. */
+		if (!list_empty(&hw->rx_pool)) {
+			packet = list_first_entry(&hw->rx_pool,
+					struct ipw_rx_packet, queue);
+			list_del_init(&packet->queue);
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+		} else {
+			/* Otherwise allocate a new one. */
+			static int min_capacity = 256;
+			int new_capacity;
+
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+			new_capacity =
+			    minimum_free_space > min_capacity
+			    ? minimum_free_space
+			    : min_capacity;
+			packet = kmalloc(sizeof(struct ipw_rx_packet)
+					+ new_capacity, GFP_ATOMIC);
+			packet->capacity = new_capacity;
+		}
+		packet->length = 0;
+	}
+
+	/*
+	 * If this packet does not have sufficient capacity for the data we
+	 * want to add, then make it bigger.
+	 */
+	if (packet->length + minimum_free_space > packet->capacity) {
+		struct ipw_rx_packet *old_packet = packet;
+
+		packet = kmalloc(sizeof(struct ipw_rx_packet) +
+				old_packet->length + minimum_free_space,
+				GFP_ATOMIC);
+		memcpy(packet, old_packet,
+				sizeof(struct ipw_rx_packet)
+					+ old_packet->length);
+		packet->capacity = old_packet->length + minimum_free_space;
+		kfree(old_packet);
+	}
+
+	return packet;
+}
+
+static void pool_free(struct ipw_hardware *hw, struct ipw_rx_packet *packet)
+{
+	static int ticker;
+
+	/*
+	 * Every now and again we release one instead of pushing it back onto
+	 * the pool.  This isn't perfectly efficient, but it prevents us
+	 * wasting memory.
+	 */
+	if ((ticker++ & 0x3f) == 0)
+		kfree(packet);
+	else
+		list_add_tail(&packet->queue, &hw->rx_pool);
+}
+
+static void queue_received_packet(struct ipw_hardware *hw,
+				  unsigned int protocol, unsigned int address,
+				  unsigned char *data, int length, int is_last)
+{
+	unsigned int channel_idx = address - 1;
+	struct ipw_rx_packet *packet = NULL;
+	unsigned long flags;
+
+	/* Discard packet if channel index is out of range. */
+	if (channel_idx >= NL_NUM_OF_ADDRESSES) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": data packet has bad address %u\n", address);
+		return;
+	}
+
+	/*
+	 * ->packet_assembler is safe to touch unlocked, this is the only place
+	 */
+	if (protocol == TL_PROTOCOLID_COM_DATA) {
+		struct ipw_rx_packet **assem =
+			&hw->packet_assembler[channel_idx];
+
+		/*
+		 * Create a new packet, or assembler already contains one
+		 * enlarge it by 'length' bytes.
+		 */
+		(*assem) = pool_allocate(hw, *assem, length);
+		(*assem)->protocol = protocol;
+		(*assem)->channel_idx = channel_idx;
+
+		/* Append this packet data onto existing data. */
+		memcpy((unsigned char *)(*assem) +
+			       sizeof(struct ipw_rx_packet)
+				+ (*assem)->length, data, length);
+		(*assem)->length += length;
+		if (is_last) {
+			packet = *assem;
+			*assem = NULL;
+			/* Count queued DATA bytes only */
+			spin_lock_irqsave(&hw->spinlock, flags);
+			hw->rx_bytes_queued += packet->length;
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+		}
+	} else {
+		/* If it's a CTRL packet, don't assemble, just queue it. */
+		packet = pool_allocate(hw, NULL, length);
+		packet->protocol = protocol;
+		packet->channel_idx = channel_idx;
+		memcpy((unsigned char *)packet + sizeof(struct ipw_rx_packet),
+				data, length);
+		packet->length = length;
+	}
+
+	/*
+	 * If this is the last packet, then send the assembled packet on to the
+	 * network layer.
+	 */
+	if (packet) {
+		spin_lock_irqsave(&hw->spinlock, flags);
+		list_add_tail(&packet->queue, &hw->rx_queue);
+		/* Block reception of incoming packets if queue is full. */
+		hw->blocking_rx =
+			hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE;
+
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+		schedule_work(&hw->work_rx);
+	}
+}
+
+/*
+ * Workqueue callback
+ */
+static void ipw_receive_data_work(struct work_struct *work_rx)
+{
+	struct ipw_hardware *hw =
+	    container_of(work_rx, struct ipw_hardware, work_rx);
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	while (!list_empty(&hw->rx_queue)) {
+		struct ipw_rx_packet *packet =
+			list_first_entry(&hw->rx_queue,
+					struct ipw_rx_packet, queue);
+
+		if (hw->shutting_down)
+			break;
+		list_del_init(&packet->queue);
+
+		/*
+		 * Note: ipwireless_network_packet_received must be called in a
+		 * process context (i.e. via schedule_work) because the tty
+		 * output code can sleep in the tty_flip_buffer_push call.
+		 */
+		if (packet->protocol == TL_PROTOCOLID_COM_DATA) {
+			if (hw->network != NULL) {
+				/* If the network hasn't been disconnected. */
+				spin_unlock_irqrestore(&hw->spinlock, flags);
+				/*
+				 * This must run unlocked due to tty processing
+				 * and mutex locking
+				 */
+				ipwireless_network_packet_received(
+						hw->network,
+						packet->channel_idx,
+						(unsigned char *)packet
+						+ sizeof(struct ipw_rx_packet),
+						packet->length);
+				spin_lock_irqsave(&hw->spinlock, flags);
+			}
+			/* Count queued DATA bytes only */
+			hw->rx_bytes_queued -= packet->length;
+		} else {
+			/*
+			 * This is safe to be called locked, callchain does
+			 * not block
+			 */
+			handle_received_CTRL_packet(hw, packet->channel_idx,
+					(unsigned char *)packet
+					+ sizeof(struct ipw_rx_packet),
+					packet->length);
+		}
+		pool_free(hw, packet);
+		/*
+		 * Unblock reception of incoming packets if queue is no longer
+		 * full.
+		 */
+		hw->blocking_rx =
+			hw->rx_bytes_queued >= IPWIRELESS_RX_QUEUE_SIZE;
+		if (hw->shutting_down)
+			break;
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+}
+
+static void handle_received_CTRL_packet(struct ipw_hardware *hw,
+					unsigned int channel_idx,
+					unsigned char *data, int len)
+{
+	struct ipw_control_packet_body *body =
+		(struct ipw_control_packet_body *) data;
+	unsigned int changed_mask;
+
+	if (len != sizeof(struct ipw_control_packet_body)) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": control packet was %d bytes - wrong size!\n",
+		       len);
+		return;
+	}
+
+	switch (body->sig_no) {
+	case ComCtrl_CTS:
+		changed_mask = IPW_CONTROL_LINE_CTS;
+		break;
+	case ComCtrl_DCD:
+		changed_mask = IPW_CONTROL_LINE_DCD;
+		break;
+	case ComCtrl_DSR:
+		changed_mask = IPW_CONTROL_LINE_DSR;
+		break;
+	case ComCtrl_RI:
+		changed_mask = IPW_CONTROL_LINE_RI;
+		break;
+	default:
+		changed_mask = 0;
+	}
+
+	if (changed_mask != 0) {
+		if (body->value)
+			hw->control_lines[channel_idx] |= changed_mask;
+		else
+			hw->control_lines[channel_idx] &= ~changed_mask;
+		if (hw->network)
+			ipwireless_network_notify_control_line_change(
+					hw->network,
+					channel_idx,
+					hw->control_lines[channel_idx],
+					changed_mask);
+	}
+}
+
+static void handle_received_packet(struct ipw_hardware *hw,
+				   union nl_packet *packet,
+				   unsigned short len)
+{
+	unsigned int protocol = packet->hdr.protocol;
+	unsigned int address = packet->hdr.address;
+	unsigned int header_length;
+	unsigned char *data;
+	unsigned int data_len;
+	int is_last = packet->hdr.packet_rank & NL_LAST_PACKET;
+
+	if (packet->hdr.packet_rank & NL_FIRST_PACKET)
+		header_length = NL_FIRST_PACKET_HEADER_SIZE;
+	else
+		header_length = NL_FOLLOWING_PACKET_HEADER_SIZE;
+
+	data = packet->rawpkt + header_length;
+	data_len = len - header_length;
+	switch (protocol) {
+	case TL_PROTOCOLID_COM_DATA:
+	case TL_PROTOCOLID_COM_CTRL:
+		queue_received_packet(hw, protocol, address, data, data_len,
+				is_last);
+		break;
+	case TL_PROTOCOLID_SETUP:
+		handle_received_SETUP_packet(hw, address, data, data_len,
+				is_last);
+		break;
+	}
+}
+
+static void acknowledge_data_read(struct ipw_hardware *hw)
+{
+	if (hw->hw_version == HW_VERSION_1)
+		outw(DCR_RXDONE, hw->base_port + IODCR);
+	else
+		iowrite16(MEMRX_PCINTACKK,
+				&hw->memory_info_regs->memreg_pc_interrupt_ack);
+}
+
+/*
+ * Retrieve a packet from the IPW hardware.
+ */
+static void do_receive_packet(struct ipw_hardware *hw)
+{
+	unsigned short len;
+	unsigned int i;
+	unsigned char pkt[LL_MTU_MAX];
+
+	start_timing();
+
+	if (hw->hw_version == HW_VERSION_1) {
+		len = inw(hw->base_port + IODRR);
+		if (len > hw->ll_mtu) {
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": received a packet of %d bytes - "
+			       "longer than the MTU!\n", (unsigned int)len);
+			outw(DCR_RXDONE | DCR_RXRESET, hw->base_port + IODCR);
+			return;
+		}
+
+		for (i = 0; i < len; i += 2) {
+			__le16 raw_data = inw(hw->base_port + IODRR);
+			unsigned short data = le16_to_cpu(raw_data);
+
+			pkt[i] = (unsigned char) data;
+			pkt[i + 1] = (unsigned char) (data >> 8);
+		}
+	} else {
+		len = inw(hw->base_port + IODMADPR);
+		if (len > hw->ll_mtu) {
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": received a packet of %d bytes - "
+			       "longer than the MTU!\n", (unsigned int)len);
+			iowrite16(MEMRX_PCINTACKK,
+				&hw->memory_info_regs->memreg_pc_interrupt_ack);
+			return;
+		}
+
+		for (i = 0; i < len; i += 2) {
+			__le16 raw_data = inw(hw->base_port + IODMADPR);
+			unsigned short data = le16_to_cpu(raw_data);
+
+			pkt[i] = (unsigned char) data;
+			pkt[i + 1] = (unsigned char) (data >> 8);
+		}
+
+		while ((i & 3) != 2) {
+			inw(hw->base_port + IODMADPR);
+			i += 2;
+		}
+	}
+
+	acknowledge_data_read(hw);
+
+	if (ipwireless_cs_debug)
+		dump_data_bytes("recv", pkt, len);
+
+	handle_received_packet(hw, (union nl_packet *) pkt, len);
+
+	end_read_timing(len);
+}
+
+static int get_current_packet_priority(struct ipw_hardware *hw)
+{
+	/*
+	 * If we're initializing, don't send anything of higher priority than
+	 * PRIO_SETUP.  The network layer therefore need not care about
+	 * hardware initialization - any of its stuff will simply be queued
+	 * until setup is complete.
+	 */
+	return (hw->to_setup || hw->initializing
+			? PRIO_SETUP + 1 :
+			NL_NUM_OF_PRIORITIES);
+}
+
+/*
+ * @return 1 if something has been received from hw
+ */
+static int get_packets_from_hw(struct ipw_hardware *hw)
+{
+	int received = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	while (hw->rx_ready && !hw->blocking_rx) {
+		received = 1;
+		hw->rx_ready--;
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		do_receive_packet(hw);
+
+		spin_lock_irqsave(&hw->spinlock, flags);
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	return received;
+}
+
+/*
+ * Send pending packet up to given priority, prioritize SETUP data until
+ * hardware is fully setup.
+ *
+ * @return 1 if more packets can be sent
+ */
+static int send_pending_packet(struct ipw_hardware *hw, int priority_limit)
+{
+	int more_to_send = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	if (hw->tx_queued && hw->tx_ready != 0) {
+		int priority;
+		struct ipw_tx_packet *packet = NULL;
+
+		hw->tx_ready--;
+
+		/* Pick a packet */
+		for (priority = 0; priority < priority_limit; priority++) {
+			if (!list_empty(&hw->tx_queue[priority])) {
+				packet = list_first_entry(
+						&hw->tx_queue[priority],
+						struct ipw_tx_packet,
+						queue);
+
+				list_del_init(&packet->queue);
+
+				break;
+			}
+		}
+		if (!packet) {
+			hw->tx_queued = 0;
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+			return 0;
+		}
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		/* Send */
+		do_send_packet(hw, packet);
+
+		/* Check if more to send */
+		spin_lock_irqsave(&hw->spinlock, flags);
+		for (priority = 0; priority < priority_limit; priority++)
+			if (!list_empty(&hw->tx_queue[priority])) {
+				more_to_send = 1;
+				break;
+			}
+
+		if (!more_to_send)
+			hw->tx_queued = 0;
+	}
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	return more_to_send;
+}
+
+/*
+ * Send and receive all queued packets. Must be called with spin_lock locked.
+ * May be called either from a interrupt tasklet, or from a process context.
+ */
+static void ipwireless_do_tasklet(unsigned long hw_)
+{
+	struct ipw_hardware *hw = (struct ipw_hardware *) hw_;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	if (hw->shutting_down) {
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+		return;
+	}
+
+	if (hw->to_setup == 1) {
+		/*
+		 * Initial setup data sent to hardware
+		 */
+		hw->to_setup = 2;
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		ipw_setup_hardware(hw);
+		ipw_send_setup_packet(hw);
+
+		send_pending_packet(hw, PRIO_SETUP + 1);
+		get_packets_from_hw(hw);
+	} else {
+		int priority_limit = get_current_packet_priority(hw);
+		int again;
+
+		spin_unlock_irqrestore(&hw->spinlock, flags);
+
+		do {
+			again = send_pending_packet(hw, priority_limit);
+			again |= get_packets_from_hw(hw);
+		} while (again);
+	}
+}
+
+/*!
+ * @return true if the card is physically present.
+ */
+static int is_card_present(struct ipw_hardware *hw)
+{
+	if (hw->hw_version == HW_VERSION_1)
+		return inw(hw->base_port + IOIR) != (unsigned short) 0xFFFF;
+	else
+		return ioread32(&hw->memory_info_regs->memreg_card_present) ==
+		    CARD_PRESENT_VALUE;
+}
+
+static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
+						  struct ipw_hardware *hw)
+{
+	unsigned short irqn;
+	unsigned short ack;
+
+	irqn = inw(hw->base_port + IOIR);
+
+	/* Check if card is present */
+	if (irqn == (unsigned short) 0xFFFF) {
+		if (++hw->bad_interrupt_count >= 100) {
+			/*
+			 * It is necessary to disable the interrupt at this
+			 * point, or the kernel hangs, interrupting repeatedly
+			 * forever.
+			 */
+			hw->irq = irq;
+			hw->removed = 1;
+			disable_irq_nosync(irq);
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+					": Mr. Fluffy is not happy!\n");
+		}
+		return IRQ_HANDLED;
+	} else if (irqn != 0) {
+		ack = 0;
+		/* Transmit complete. */
+		if (irqn & IR_TXINTR) {
+			hw->tx_ready++;
+			ack |= IR_TXINTR;
+		}
+
+		/* Received data */
+		if (irqn & IR_RXINTR) {
+			ack |= IR_RXINTR;
+			hw->rx_ready++;
+		}
+		if (ack != 0) {
+			outw(ack, hw->base_port + IOIR);
+			tasklet_schedule(&hw->tasklet);
+		}
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
+
+}
+
+static void acknowledge_pcmcia_interrupt(struct ipw_hardware *hw)
+{
+	unsigned short csr = ioread16(&hw->memregs_CCR->PCCSR);
+
+	csr &= 0xfffd;
+	iowrite16(csr, &hw->memregs_CCR->PCCSR);
+}
+
+static irqreturn_t ipwireless_handle_v2_v3_interrupt(int irq,
+						     struct ipw_hardware *hw)
+{
+	int tx = 0;
+	int rx = 0;
+	int rx_repeat = 0;
+	int try_mem_tx_old;
+
+	do {
+
+	unsigned short memtx = ioread16(hw->memreg_tx);
+	unsigned short memtx_serial;
+	unsigned short memrxdone =
+		ioread16(&hw->memory_info_regs->memreg_rx_done);
+
+	try_mem_tx_old = 0;
+
+	/* check whether the interrupt was generated by ipwireless card */
+	if (!(memtx & MEMTX_TX) && !(memrxdone & MEMRX_RX_DONE)) {
+
+		/* check if the card uses memreg_tx_old register */
+		if (hw->memreg_tx == &hw->memory_info_regs->memreg_tx_new) {
+			memtx = ioread16(&hw->memory_info_regs->memreg_tx_old);
+			if (memtx & MEMTX_TX) {
+				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+					": Using memreg_tx_old\n");
+				hw->memreg_tx =
+					&hw->memory_info_regs->memreg_tx_old;
+			} else {
+				return IRQ_NONE;
+			}
+		} else {
+			return IRQ_NONE;
+		}
+	}
+
+	/*
+	 * See if the card is physically present. Note that while it is
+	 * powering up, it appears not to be present.
+	 */
+	if (!is_card_present(hw)) {
+		acknowledge_pcmcia_interrupt(hw);
+		return IRQ_HANDLED;
+	}
+
+	memtx_serial = memtx & (unsigned short) 0xff00;
+	if (memtx & MEMTX_TX) {
+		iowrite16(memtx_serial, hw->memreg_tx);
+
+		if (hw->serial_number_detected) {
+			if (memtx_serial != hw->last_memtx_serial) {
+				hw->last_memtx_serial = memtx_serial;
+				hw->rx_ready++;
+				rx = 1;
+			} else
+				/* Ignore 'Timer Recovery' duplicates. */
+				rx_repeat = 1;
+		} else {
+			/*
+			 * If a non-zero serial number is seen, then enable
+			 * serial number checking.
+			 */
+			if (memtx_serial != 0)
+				hw->serial_number_detected = 1;
+				printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+					": memreg_tx serial num detected\n");
+
+			hw->rx_ready++;
+			rx = 1;
+		}
+	}
+	if (memrxdone & MEMRX_RX_DONE) {
+		iowrite16(0, &hw->memory_info_regs->memreg_rx_done);
+		hw->tx_ready++;
+		tx = 1;
+	}
+	if (tx)
+		iowrite16(MEMRX_PCINTACKK,
+				&hw->memory_info_regs->memreg_pc_interrupt_ack);
+
+	acknowledge_pcmcia_interrupt(hw);
+
+	if (tx || rx)
+		tasklet_schedule(&hw->tasklet);
+	else if (!rx_repeat) {
+		if (hw->memreg_tx == &hw->memory_info_regs->memreg_tx_new) {
+			if (hw->serial_number_detected)
+				printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
+					": spurious interrupt - new_tx mode\n");
+			else {
+				printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
+					": no valid memreg_tx value - "
+					"switching to the old memreg_tx\n");
+				hw->memreg_tx =
+					&hw->memory_info_regs->memreg_tx_old;
+				try_mem_tx_old = 1;
+			}
+		} else
+			printk(KERN_WARNING IPWIRELESS_PCCARD_NAME
+					": spurious interrupt - old_tx mode\n");
+	}
+
+	} while (try_mem_tx_old == 1);
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+{
+	struct ipw_hardware *hw = (struct ipw_hardware *) dev_id;
+
+	if (hw->hw_version == HW_VERSION_1)
+		return ipwireless_handle_v1_interrupt(irq, hw);
+	else
+		return ipwireless_handle_v2_v3_interrupt(irq, hw);
+}
+
+static void flush_packets_to_hw(struct ipw_hardware *hw)
+{
+	int priority_limit;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	priority_limit = get_current_packet_priority(hw);
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	while (send_pending_packet(hw, priority_limit));
+}
+
+static void send_packet(struct ipw_hardware *hw, int priority,
+			struct ipw_tx_packet *packet)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hw->spinlock, flags);
+	list_add_tail(&packet->queue, &hw->tx_queue[priority]);
+	hw->tx_queued = 1;
+	spin_unlock_irqrestore(&hw->spinlock, flags);
+
+	flush_packets_to_hw(hw);
+}
+
+static void *create_packet(int packet_size,
+			   unsigned char dest_addr,
+			   unsigned char protocol,
+			   void (*packet_sent_callback) (struct ipw_tx_packet *
+							 packet))
+{
+	struct ipw_tx_packet *packet = kzalloc(packet_size, GFP_ATOMIC);
+
+	INIT_LIST_HEAD(&packet->queue);
+	packet->dest_addr = dest_addr;
+	packet->protocol = protocol;
+	packet->packet_sent_callback = packet_sent_callback;
+	packet->length = packet_size - sizeof(struct ipw_tx_packet);
+	return packet;
+}
+
+void ipwireless_send_packet(struct ipw_hardware *hw, unsigned int channel_idx,
+			    unsigned char *data, unsigned int length,
+			    void (*callback) (void *cb, unsigned int length),
+			    void *callback_data)
+{
+	struct ipw_tx_packet *packet;
+
+	packet = create_packet(sizeof(struct ipw_tx_packet) + length,
+			       (unsigned char) (channel_idx + 1),
+			       TL_PROTOCOLID_COM_DATA,
+			       free_packet_and_callback);
+	packet->external_callback = callback;
+	packet->external_callback_data = callback_data;
+	memcpy((unsigned char *) packet +
+			sizeof(struct ipw_tx_packet), data, length);
+
+	send_packet(hw, PRIO_DATA, packet);
+}
+
+static void set_control_line(struct ipw_hardware *hw, int prio,
+			   unsigned int channel_idx, int line, int state)
+{
+	struct ipw_control_packet *packet;
+	int protocolid = TL_PROTOCOLID_COM_CTRL;
+
+	if (prio == PRIO_SETUP)
+		protocolid = TL_PROTOCOLID_SETUP;
+
+	packet = create_packet(sizeof(struct ipw_control_packet),
+			(unsigned char) (channel_idx + 1),
+			protocolid, free_packet);
+	packet->packet.length = sizeof(struct ipw_control_packet_body);
+	packet->body.sig_no = (unsigned char) line;
+	packet->body.value = (unsigned char) (state == 0 ? 0 : 1);
+	send_packet(hw, prio, &packet->packet);
+}
+
+
+static void set_DTR(struct ipw_hardware *hw, int priority,
+		   unsigned int channel_idx, int state)
+{
+	if (state != 0)
+		hw->control_lines[channel_idx] |= IPW_CONTROL_LINE_DTR;
+	else
+		hw->control_lines[channel_idx] &= ~IPW_CONTROL_LINE_DTR;
+
+	set_control_line(hw, priority, channel_idx, ComCtrl_DTR, state);
+}
+
+static void set_RTS(struct ipw_hardware *hw, int priority,
+		   unsigned int channel_idx, int state)
+{
+	if (state != 0)
+		hw->control_lines[channel_idx] |= IPW_CONTROL_LINE_RTS;
+	else
+		hw->control_lines[channel_idx] &= ~IPW_CONTROL_LINE_RTS;
+
+	set_control_line(hw, priority, channel_idx, ComCtrl_RTS, state);
+}
+
+void ipwireless_set_DTR(struct ipw_hardware *hw, unsigned int channel_idx,
+		       int state)
+{
+	set_DTR(hw, PRIO_CTRL, channel_idx, state);
+}
+
+void ipwireless_set_RTS(struct ipw_hardware *hw, unsigned int channel_idx,
+		       int state)
+{
+	set_RTS(hw, PRIO_CTRL, channel_idx, state);
+}
+
+struct ipw_setup_get_version_query_packet {
+	struct ipw_tx_packet packet;
+	struct TlSetupGetVersionQry body;
+};
+
+struct ipw_setup_config_packet {
+	struct ipw_tx_packet packet;
+	struct TlSetupConfigMsg body;
+};
+
+struct ipw_setup_config_done_packet {
+	struct ipw_tx_packet packet;
+	struct TlSetupConfigDoneMsg body;
+};
+
+struct ipw_setup_open_packet {
+	struct ipw_tx_packet packet;
+	struct TlSetupOpenMsg body;
+};
+
+struct ipw_setup_info_packet {
+	struct ipw_tx_packet packet;
+	struct TlSetupInfoMsg body;
+};
+
+struct ipw_setup_reboot_msg_ack {
+	struct ipw_tx_packet packet;
+	struct TlSetupRebootMsgAck body;
+};
+
+/* This handles the actual initialization of the card */
+static void __handle_setup_get_version_rsp(struct ipw_hardware *hw)
+{
+	struct ipw_setup_config_packet *config_packet;
+	struct ipw_setup_config_done_packet *config_done_packet;
+	struct ipw_setup_open_packet *open_packet;
+	struct ipw_setup_info_packet *info_packet;
+	int port;
+	unsigned int channel_idx;
+
+	/* generate config packet */
+	for (port = 1; port <= NL_NUM_OF_ADDRESSES; port++) {
+		config_packet = create_packet(
+				sizeof(struct ipw_setup_config_packet),
+				ADDR_SETUP_PROT,
+				TL_PROTOCOLID_SETUP,
+				free_packet);
+		config_packet->packet. length = sizeof(struct TlSetupConfigMsg);
+		config_packet->body.sig_no = TL_SETUP_SIGNO_CONFIG_MSG;
+		config_packet->body.port_no = port;
+		config_packet->body.prio_data = PRIO_DATA;
+		config_packet->body.prio_ctrl = PRIO_CTRL;
+		send_packet(hw, PRIO_SETUP, &config_packet->packet);
+	}
+	config_done_packet = create_packet(
+			sizeof(struct ipw_setup_config_done_packet),
+			ADDR_SETUP_PROT,
+			TL_PROTOCOLID_SETUP,
+			free_packet);
+	config_done_packet->packet.length = sizeof(struct TlSetupConfigDoneMsg);
+	config_done_packet->body.sig_no = TL_SETUP_SIGNO_CONFIG_DONE_MSG;
+	send_packet(hw, PRIO_SETUP, &config_done_packet->packet);
+
+	/* generate open packet */
+	for (port = 1; port <= NL_NUM_OF_ADDRESSES; port++) {
+		open_packet = create_packet(
+				sizeof(struct ipw_setup_open_packet),
+				ADDR_SETUP_PROT,
+				TL_PROTOCOLID_SETUP,
+				free_packet);
+		open_packet->packet.length = sizeof(struct TlSetupOpenMsg);
+		open_packet->body.sig_no = TL_SETUP_SIGNO_OPEN_MSG;
+		open_packet->body.port_no = port;
+		send_packet(hw, PRIO_SETUP, &open_packet->packet);
+	}
+	for (channel_idx = 0;
+			channel_idx < NL_NUM_OF_ADDRESSES; channel_idx++) {
+		set_DTR(hw, PRIO_SETUP, channel_idx,
+			(hw->control_lines[channel_idx] &
+			 IPW_CONTROL_LINE_DTR) != 0);
+		set_RTS(hw, PRIO_SETUP, channel_idx,
+			(hw->control_lines [channel_idx] &
+			 IPW_CONTROL_LINE_RTS) != 0);
+	}
+	/*
+	 * For NDIS we assume that we are using sync PPP frames, for COM async.
+	 * This driver uses NDIS mode too. We don't bother with translation
+	 * from async -> sync PPP.
+	 */
+	info_packet = create_packet(sizeof(struct ipw_setup_info_packet),
+			ADDR_SETUP_PROT,
+			TL_PROTOCOLID_SETUP,
+			free_packet);
+	info_packet->packet.length = sizeof(struct TlSetupInfoMsg);
+	info_packet->body.sig_no = TL_SETUP_SIGNO_INFO_MSG;
+	info_packet->body.driver_type = NDISWAN_DRIVER;
+	info_packet->body.major_version = NDISWAN_DRIVER_MAJOR_VERSION;
+	info_packet->body.minor_version = NDISWAN_DRIVER_MINOR_VERSION;
+	send_packet(hw, PRIO_SETUP, &info_packet->packet);
+
+	/* Initialization is now complete, so we clear the 'to_setup' flag */
+	hw->to_setup = 0;
+}
+
+static void handle_setup_get_version_rsp(struct ipw_hardware *hw,
+		unsigned char vers_no)
+{
+	del_timer(&hw->setup_timer);
+	hw->initializing = 0;
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME ": card is ready.\n");
+
+	if (vers_no == TL_SETUP_VERSION)
+		__handle_setup_get_version_rsp(hw);
+	else
+		printk(KERN_ERR
+				IPWIRELESS_PCCARD_NAME
+				": invalid hardware version no %u\n",
+				(unsigned int) vers_no);
+}
+
+static void ipw_send_setup_packet(struct ipw_hardware *hw)
+{
+	struct ipw_setup_get_version_query_packet *ver_packet;
+
+	ver_packet = create_packet(
+			sizeof(struct ipw_setup_get_version_query_packet),
+			ADDR_SETUP_PROT, TL_PROTOCOLID_SETUP, free_packet);
+	ver_packet->body.sig_no = TL_SETUP_SIGNO_GET_VERSION_QRY;
+	ver_packet->packet.length = sizeof(struct TlSetupGetVersionQry);
+
+	/*
+	 * Response is handled in handle_received_SETUP_packet
+	 */
+	send_packet(hw, PRIO_SETUP, &ver_packet->packet);
+}
+
+static void handle_received_SETUP_packet(struct ipw_hardware *hw,
+					 unsigned int address,
+					 unsigned char *data, int len,
+					 int is_last)
+{
+	union ipw_setup_rx_msg *rx_msg = (union ipw_setup_rx_msg *) data;
+
+	if (address != ADDR_SETUP_PROT) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": setup packet has bad address %d\n", address);
+		return;
+	}
+
+	switch (rx_msg->sig_no) {
+	case TL_SETUP_SIGNO_GET_VERSION_RSP:
+		if (hw->to_setup)
+			handle_setup_get_version_rsp(hw,
+					rx_msg->VersRspMsg.version);
+		break;
+
+	case TL_SETUP_SIGNO_OPEN_MSG:
+		if (ipwireless_cs_debug) {
+			unsigned int channel_idx = rx_msg->OpenMsg.port_no - 1;
+
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": OPEN_MSG [channel %u] reply received\n",
+			       channel_idx);
+		}
+		break;
+
+	case TL_SETUP_SIGNO_INFO_MSG_ACK:
+		if (ipwireless_cs_debug)
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+			       ": card successfully configured as NDISWAN\n");
+		break;
+
+	case TL_SETUP_SIGNO_REBOOT_MSG:
+		if (hw->to_setup)
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+			       ": Setup not completed - ignoring reboot msg\n");
+		else {
+			struct ipw_setup_reboot_msg_ack *packet;
+
+			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
+			       ": Acknowledging REBOOT message\n");
+			packet = create_packet(
+					sizeof(struct ipw_setup_reboot_msg_ack),
+					ADDR_SETUP_PROT, TL_PROTOCOLID_SETUP,
+					free_packet);
+			packet->packet.length =
+				sizeof(struct TlSetupRebootMsgAck);
+			packet->body.sig_no = TL_SETUP_SIGNO_REBOOT_MSG_ACK;
+			send_packet(hw, PRIO_SETUP, &packet->packet);
+			if (hw->reboot_callback)
+				hw->reboot_callback(hw->reboot_callback_data);
+		}
+		break;
+
+	default:
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": unknown setup message %u received\n",
+		       (unsigned int) rx_msg->sig_no);
+	}
+}
+
+static void do_close_hardware(struct ipw_hardware *hw)
+{
+	unsigned int irqn;
+
+	if (hw->hw_version == HW_VERSION_1) {
+		/* Disable TX and RX interrupts. */
+		outw(0, hw->base_port + IOIER);
+
+		/* Acknowledge any outstanding interrupt requests */
+		irqn = inw(hw->base_port + IOIR);
+		if (irqn & IR_TXINTR)
+			outw(IR_TXINTR, hw->base_port + IOIR);
+		if (irqn & IR_RXINTR)
+			outw(IR_RXINTR, hw->base_port + IOIR);
+	}
+}
+
+struct ipw_hardware *ipwireless_hardware_create(struct ipw_config *config)
+{
+	int i;
+	struct ipw_hardware *hw =
+		kzalloc(sizeof(struct ipw_hardware), GFP_KERNEL);
+
+	if (!hw)
+		return NULL;
+
+	hw->initializing = 1;
+	hw->tx_ready = 1;
+	memcpy(&hw->config, config, sizeof(struct ipw_config));
+	for (i = 0; i < NL_NUM_OF_PRIORITIES; i++)
+		INIT_LIST_HEAD(&hw->tx_queue[i]);
+
+	hw->rx_bytes_queued = 0;
+	INIT_LIST_HEAD(&hw->rx_queue);
+	INIT_LIST_HEAD(&hw->rx_pool);
+
+	spin_lock_init(&hw->spinlock);
+	tasklet_init(&hw->tasklet, ipwireless_do_tasklet, (unsigned long) hw);
+
+	init_timer(&hw->setup_timer);
+	hw->setup_timer.function = ipwireless_setup_timer;
+	hw->setup_timer.data = (unsigned long) hw;
+
+	INIT_WORK(&hw->work_rx, ipw_receive_data_work);
+
+	hw->last_memtx_serial = (unsigned short) 0xffff;
+
+	return hw;
+}
+
+void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
+		unsigned int base_port,
+		void __iomem *attr_memory,
+		void __iomem *common_memory,
+		int is_v2_card,
+		void (*reboot_callback) (void *data),
+		void *reboot_callback_data)
+{
+	hw->bad_interrupt_count = 0;
+	if (hw->removed) {
+		hw->removed = 0;
+		enable_irq(hw->irq);
+	}
+	hw->base_port = base_port;
+	hw->hw_version = is_v2_card ? HW_VERSION_2 : HW_VERSION_1;
+	hw->ll_mtu = hw->hw_version == HW_VERSION_1 ? LL_MTU_V1 : LL_MTU_V2;
+	hw->memregs_CCR = (struct MEMCCR __iomem *)
+			((unsigned short __iomem *) attr_memory + 0x200);
+	hw->memory_info_regs = (struct MEMINFREG __iomem *) common_memory;
+	hw->memreg_tx = &hw->memory_info_regs->memreg_tx_new;
+	hw->reboot_callback = reboot_callback;
+	hw->reboot_callback_data = reboot_callback_data;
+}
+
+void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw)
+{
+	hw->initializing = 1;
+	hw->init_loops = 0;
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+	       ": waiting for card to start up...\n");
+	ipwireless_setup_timer((unsigned long) hw);
+}
+
+static void ipwireless_setup_timer(unsigned long data)
+{
+	struct ipw_hardware *hw = (struct ipw_hardware *) data;
+
+	hw->init_loops++;
+
+	if (hw->init_loops == TL_SETUP_MAX_VERSION_QRY &&
+			hw->hw_version == HW_VERSION_2 &&
+			hw->memreg_tx == &hw->memory_info_regs->memreg_tx_new) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				": failed to startup using TX2, trying TX\n");
+
+		hw->memreg_tx = &hw->memory_info_regs->memreg_tx_old;
+		hw->init_loops = 0;
+	}
+	/* Give up after a certain number of retries */
+	if (hw->init_loops == TL_SETUP_MAX_VERSION_QRY) {
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+		       ": card failed to start up!\n");
+		hw->initializing = 0;
+	} else {
+		/* Do not attempt to write to the board if it is not present. */
+		if (is_card_present(hw)) {
+			unsigned long flags;
+
+			hw->to_setup = 1;
+			hw->tx_ready = 1;
+			spin_lock_irqsave(&hw->spinlock, flags);
+			tasklet_schedule(&hw->tasklet);
+			spin_unlock_irqrestore(&hw->spinlock, flags);
+		}
+
+		hw->setup_timer.expires = jiffies + (unsigned long)
+			TL_SETUP_VERSION_QRY_TMO * HZ / 1000UL;
+		add_timer(&hw->setup_timer);
+	}
+}
+
+/*
+ * Stop any interrupts from executing so that, once this function returns,
+ * other layers of the driver can be sure they won't get any more callbacks.
+ * Thus must be called on a proper process context.
+ */
+void ipwireless_stop_interrupts(struct ipw_hardware *hw)
+{
+	if (!hw->shutting_down) {
+		/* Tell everyone we are going down. */
+		hw->shutting_down = 1;
+		del_timer(&hw->setup_timer);
+
+		/* Prevent the hardware from sending any more interrupts */
+		do_close_hardware(hw);
+	}
+}
+
+void ipwireless_hardware_free(struct ipw_hardware *hw)
+{
+	int i;
+	struct ipw_rx_packet *rp, *rq;
+	struct ipw_tx_packet *tp, *tq;
+
+	ipwireless_stop_interrupts(hw);
+
+	flush_scheduled_work();
+
+	for (i = 0; i < NL_NUM_OF_ADDRESSES; i++)
+		if (hw->packet_assembler[i] != NULL)
+			kfree(hw->packet_assembler[i]);
+
+	for (i = 0; i < NL_NUM_OF_PRIORITIES; i++)
+		list_for_each_entry_safe(tp, tq, &hw->tx_queue[i], queue) {
+			list_del_init(&tp->queue);
+			kfree(tp);
+		}
+
+	list_for_each_entry_safe(rp, rq, &hw->rx_queue, queue) {
+		list_del_init(&rp->queue);
+		kfree(rp);
+	}
+
+	list_for_each_entry_safe(rp, rq, &hw->rx_pool, queue) {
+		list_del_init(&rp->queue);
+		kfree(rp);
+	}
+	kfree(hw);
+}
+
+/*
+ * Associate the specified network with this hardware, so it will receive events
+ * from it.
+ */
+void ipwireless_associate_network(struct ipw_hardware *hw,
+				  struct ipw_network *network)
+{
+	hw->network = network;
+}
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_hardware.h
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_hardware.h
@@ -0,0 +1,64 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_HARDWARE_H_
+#define _IPWIRELESS_CS_HARDWARE_H_
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+
+#define IPW_CONTROL_LINE_CTS 0x0001
+#define IPW_CONTROL_LINE_DCD 0x0002
+#define IPW_CONTROL_LINE_DSR 0x0004
+#define IPW_CONTROL_LINE_RI  0x0008
+#define IPW_CONTROL_LINE_DTR 0x0010
+#define IPW_CONTROL_LINE_RTS 0x0020
+
+struct ipw_config;
+struct ipw_hardware;
+struct ipw_network;
+
+struct ipw_hardware *ipwireless_hardware_create(struct ipw_config *cfg);
+void ipwireless_hardware_free(struct ipw_hardware *hw);
+irqreturn_t ipwireless_interrupt(int irq, void *dev_id, struct pt_regs *regs);
+void ipwireless_set_DTR(struct ipw_hardware *hw, unsigned int channel_idx,
+		int state);
+void ipwireless_set_RTS(struct ipw_hardware *hw, unsigned int channel_idx,
+		int state);
+void ipwireless_send_packet(struct ipw_hardware *hw,
+			    unsigned int channel_idx,
+			    unsigned char *data,
+			    unsigned int length,
+			    void (*packet_sent_callback) (void *cb,
+							  unsigned int length),
+			    void *sent_cb_data);
+void ipwireless_associate_network(struct ipw_hardware *hw,
+		struct ipw_network *net);
+void ipwireless_stop_interrupts(struct ipw_hardware *hw);
+void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
+				 unsigned int base_port,
+				 void __iomem *attr_memory,
+				 void __iomem *common_memory,
+				 int is_v2_card,
+				 void (*reboot_cb) (void *data),
+				 void *reboot_cb_data);
+void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw);
+void ipwireless_sleep(unsigned int tenths);
+int ipwireless_dump_hardware_state(char *p, struct ipw_hardware *hw);
+
+#endif
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_main.c
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_main.c
@@ -0,0 +1,482 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include "ipwireless_cs_hardware.h"
+#include "ipwireless_cs_network.h"
+#include "ipwireless_cs_main.h"
+#include "ipwireless_cs_tty.h"
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/io.h>
+
+#include <pcmcia/version.h>
+#include <pcmcia/cisreg.h>
+#include <pcmcia/device_id.h>
+#include <pcmcia/ss.h>
+#include <pcmcia/ds.h>
+#include <pcmcia/cs.h>
+#include <linux/delay.h>
+
+static struct ipw_config default_config = {
+	"*99#"			/* phone number */
+};
+
+static struct pcmcia_device_id ipw_ids[] = {
+	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0100),
+	PCMCIA_DEVICE_MANF_CARD(0x02f2, 0x0200),
+	PCMCIA_DEVICE_NULL
+};
+MODULE_DEVICE_TABLE(pcmcia, ipw_ids);
+
+static void ipwireless_detach(struct pcmcia_device *link);
+
+/* Options configurable through the proc filesystem. */
+__u16 ipwireless_cs_debug;
+__u16 ipwireless_cs_loopback;
+__u16 ipwireless_cs_out_queue = 1;
+static int major;
+
+module_param(major, int, 0);
+MODULE_PARM_DESC(major, "ttyIPWp major number [0]");
+
+static char *drv_name = IPWIRELESS_PCCARD_NAME;
+
+/* Executes in process context. */
+static void signalled_reboot_work(struct work_struct *work_reboot)
+{
+	struct ipw_dev *ipw = container_of(work_reboot, struct ipw_dev,
+			work_reboot);
+	struct pcmcia_device *link = ipw->link;
+	int ret = pccard_reset_card(link->socket);
+
+	if (ret != CS_SUCCESS)
+		cs_error(link, ResetCard, ret);
+}
+
+static void signalled_reboot_callback(void *callback_data)
+{
+	struct ipw_dev *ipw = (struct ipw_dev *) callback_data;
+
+	/* Delegate to process context. */
+	schedule_work(&ipw->work_reboot);
+}
+
+static int config_ipwireless(struct ipw_dev *ipw)
+{
+	struct pcmcia_device *link = ipw->link;
+	int ret;
+	config_info_t conf;
+	tuple_t tuple;
+	unsigned short buf[64];
+	cisparse_t parse;
+	unsigned short cor_value;
+	win_req_t reqAM;
+	win_req_t reqCM;
+	memreq_t memAM;
+	memreq_t memCM;
+
+	ipw->isV2Card = 0;
+
+	tuple.Attributes = 0;
+	tuple.TupleData = (cisdata_t *) buf;
+	tuple.TupleDataMax = sizeof(buf);
+	tuple.TupleOffset = 0;
+
+	tuple.DesiredTuple = RETURN_FIRST_TUPLE;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	while (ret == 0) {
+		ret = pcmcia_get_tuple_data(link, &tuple);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, GetTupleData, ret);
+			goto exit0;
+		}
+		ret = pcmcia_get_next_tuple(link, &tuple);
+	}
+
+	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetFirstTuple, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_get_tuple_data(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_parse_tuple(link, &tuple, &parse);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, ParseTuple, ret);
+		goto exit0;
+	}
+
+	link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
+	link->io.BasePort1 = parse.cftable_entry.io.win[0].base;
+	link->io.NumPorts1 = parse.cftable_entry.io.win[0].len;
+	link->io.IOAddrLines = 16;
+
+	link->irq.IRQInfo1 = parse.cftable_entry.irq.IRQInfo1;
+
+	/* 0x40 causes it to generate level mode interrupts. */
+	/* 0x04 enables IREQ pin. */
+	cor_value = parse.cftable_entry.index | 0x44;
+	link->conf.ConfigIndex = cor_value;
+
+	/* IRQ and I/O settings */
+	tuple.DesiredTuple = CISTPL_CONFIG;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetFirstTuple, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_get_tuple_data(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit0;
+	}
+
+	ret = pcmcia_parse_tuple(link, &tuple, &parse);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit0;
+	}
+	link->conf.Attributes = CONF_ENABLE_IRQ;
+	link->conf.ConfigBase = parse.config.base;
+	link->conf.Present = parse.config.rmask[0];
+	link->conf.IntType = INT_MEMORY_AND_IO;
+
+	link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING | IRQ_HANDLE_PRESENT;
+	link->irq.Handler = ipwireless_interrupt;
+	link->irq.Instance = ipw->hardware;
+
+	ret = pcmcia_request_io(link, &link->io);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, RequestIO, ret);
+		goto exit0;
+	}
+
+	/* memory settings */
+
+	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
+
+	ret = pcmcia_get_first_tuple(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetFirstTuple, ret);
+		goto exit1;
+	}
+
+	ret = pcmcia_get_tuple_data(link, &tuple);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetTupleData, ret);
+		goto exit1;
+	}
+
+	ret = pcmcia_parse_tuple(link, &tuple, &parse);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, ParseTuple, ret);
+		goto exit1;
+	}
+
+	if (parse.cftable_entry.mem.nwin > 0) {
+		reqCM.Attributes =
+			WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_CM | WIN_ENABLE;
+		reqCM.Base = parse.cftable_entry.mem.win[0].host_addr;
+		reqCM.Size = parse.cftable_entry.mem.win[0].len;
+		if (reqCM.Size < 0x1000)
+			reqCM.Size = 0x1000;
+		reqCM.AccessSpeed = 0;
+
+		ret = pcmcia_request_window(&link, &reqCM, &ipw->handleCM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, RequestWindow, ret);
+			goto exit1;
+		}
+
+		memCM.CardOffset = parse.cftable_entry.mem.win[0].card_addr;
+		memCM.Page = 0;
+
+		ret = pcmcia_map_mem_page(ipw->handleCM, &memCM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, MapMemPage, ret);
+			goto exit1;
+		}
+
+		ipw->isV2Card =
+			parse.cftable_entry.mem.win[0].len == 0x100;
+
+		ipw->commonMemory = ioremap(reqCM.Base, reqCM.Size);
+
+		reqAM.Attributes =
+			WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_AM | WIN_ENABLE;
+		reqAM.Base = 0;
+		reqAM.Size = 0;	/* this used to be 0x1000 */
+		reqAM.AccessSpeed = 0;
+
+		ret = pcmcia_request_window(&link, &reqAM, &ipw->handleAM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, RequestWindow, ret);
+			goto exit2;
+		}
+
+		memAM.CardOffset = 0;
+		memAM.Page = 0;
+
+		ret = pcmcia_map_mem_page(ipw->handleAM, &memAM);
+
+		if (ret != CS_SUCCESS) {
+			cs_error(link, MapMemPage, ret);
+			goto exit2;
+		}
+
+		ipw->attrMemory = ioremap(reqAM.Base, reqAM.Size);
+	}
+
+	INIT_WORK(&ipw->work_reboot, signalled_reboot_work);
+
+	ipwireless_init_hardware_v1(ipw->hardware, link->io.BasePort1,
+				    ipw->attrMemory, ipw->commonMemory,
+				    ipw->isV2Card, signalled_reboot_callback,
+				    ipw);
+
+	ret = pcmcia_request_irq(link, &link->irq);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, RequestIRQ, ret);
+		goto exit3;
+	}
+
+	/* Look up current Vcc */
+
+	ret = pcmcia_get_configuration_info(link, &conf);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, GetConfigurationInfo, ret);
+		goto exit4;
+	}
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME ": Card type %s\n",
+			ipw->isV2Card ? "V2/V3" : "V1");
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			": I/O ports 0x%04x-0x%04x, irq %d\n",
+			(unsigned int) link->io.BasePort1,
+			(unsigned int) (link->io.BasePort1 +
+				link->io.NumPorts1 - 1),
+			(unsigned int) link->irq.AssignedIRQ);
+	if (ipw->attrMemory && ipw->commonMemory)
+		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				": attr memory 0x%08lx-0x%08lx, "
+				"common memory 0x%08lx-0x%08lx\n",
+				(unsigned long)reqAM.Base,
+				(unsigned long)reqAM.Base +
+					(unsigned long)reqAM.Size -
+					(unsigned long) 1,
+				(unsigned long)reqCM.Base,
+				(unsigned long)reqCM.Base +
+					(unsigned long)reqCM.Size -
+					(unsigned long) 1);
+
+	ipw->network = ipwireless_network_create(ipw->hardware);
+	ipw->tty = ipwireless_tty_create(ipw->hardware, ipw->network,
+			ipw->nodes);
+
+	ipwireless_init_hardware_v2_v3(ipw->hardware);
+
+	/*
+	 * Do the RequestConfiguration last, because it enables interrupts.
+	 * Then we don't get any interrupts before we're ready for them.
+	 */
+	ret = pcmcia_request_configuration(link, &link->conf);
+
+	if (ret != CS_SUCCESS) {
+		cs_error(link, RequestConfiguration, ret);
+		goto exit4;
+	}
+
+	link->dev_node = &ipw->nodes[0];
+
+	return 0;
+
+exit4:
+	pcmcia_disable_device(link);
+exit3:
+	if (ipw->attrMemory) {
+		iounmap(ipw->attrMemory);
+		pcmcia_release_window(ipw->handleAM);
+		pcmcia_disable_device(link);
+	}
+exit2:
+	if (ipw->commonMemory) {
+		iounmap(ipw->commonMemory);
+		pcmcia_release_window(ipw->handleCM);
+	}
+exit1:
+	pcmcia_disable_device(link);
+exit0:
+	return -1;
+}
+
+static void release_ipwireless(struct ipw_dev *ipw)
+{
+	struct pcmcia_device *link = ipw->link;
+
+	pcmcia_disable_device(link);
+
+	if (ipw->commonMemory)
+		iounmap(ipw->commonMemory);
+	if (ipw->attrMemory)
+		iounmap(ipw->attrMemory);
+	if (ipw->commonMemory)
+		pcmcia_release_window(ipw->handleCM);
+	if (ipw->attrMemory)
+		pcmcia_release_window(ipw->handleAM);
+	pcmcia_disable_device(link);
+}
+
+/*
+ * ipwireless_attach() creates an "instance" of the driver, allocating
+ * local data structures for one device (one interface).  The device
+ * is registered with Card Services.
+ *
+ * The pcmcia_device structure is initialized, but we don't actually
+ * configure the card at this point -- we wait until we receive a
+ * card insertion event.
+ */
+static int ipwireless_attach(struct pcmcia_device *link)
+{
+	struct ipw_dev *ipw;
+	int ret;
+
+	ipw = kzalloc(sizeof(struct ipw_dev), GFP_KERNEL);
+
+	ipw->link = link;
+	link->priv = ipw;
+	link->irq.Instance = ipw;
+
+	/* Link this device into our device list. */
+	link->dev_node = &ipw->nodes[0];
+
+	ipw->hardware = ipwireless_hardware_create(&default_config);
+	/* RegisterClient will call config_ipwireless */
+
+	ret = config_ipwireless(ipw);
+
+	if (ret != 0) {
+		cs_error(link, RegisterClient, ret);
+		ipwireless_detach(link);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * This deletes a driver "instance".  The device is de-registered with
+ * Card Services.  If it has been released, all local data structures
+ * are freed.  Otherwise, the structures will be freed when the device
+ * is released.
+ */
+static void ipwireless_detach(struct pcmcia_device *link)
+{
+	struct ipw_dev *ipw = (struct ipw_dev *) link->priv;
+
+	release_ipwireless(ipw);
+
+	/* Break the link with Card Services */
+	if (link)
+		pcmcia_disable_device(link);
+
+	if (ipw->tty != NULL)
+		ipwireless_tty_free(ipw->tty);
+	if (ipw->network != NULL)
+		ipwireless_network_free(ipw->network);
+	if (ipw->hardware != NULL)
+		ipwireless_hardware_free(ipw->hardware);
+	kfree(ipw);
+}
+
+static struct pcmcia_driver me;
+
+/*
+ * Module insertion : initialisation of the module.
+ * Register the card with cardmgr...
+ */
+static int __init init_ipwireless_cs(void)
+{
+	int ret;
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME " "
+	       IPWIRELESS_PCMCIA_VERSION " by " IPWIRELESS_PCMCIA_AUTHOR "\n");
+	me.owner = THIS_MODULE;
+	me.probe = ipwireless_attach;
+	me.remove = ipwireless_detach;
+	me.drv.name = drv_name;
+	me.id_table = ipw_ids;
+	pcmcia_register_driver(&me);
+
+	ret = ipwireless_tty_init(major);
+	if (ret != 0)
+		pcmcia_unregister_driver(&me);
+	return ret;
+}
+
+/*
+ * Module removal
+ */
+static void __exit exit_ipwireless_cs(void)
+{
+	ipwireless_tty_release();
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME " "
+			IPWIRELESS_PCMCIA_VERSION " removed\n");
+
+	pcmcia_unregister_driver(&me);
+}
+
+module_init(init_ipwireless_cs);
+module_exit(exit_ipwireless_cs);
+
+MODULE_AUTHOR(IPWIRELESS_PCMCIA_AUTHOR);
+MODULE_DESCRIPTION(IPWIRELESS_PCCARD_NAME " " IPWIRELESS_PCMCIA_VERSION);
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_main.h
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_main.h
@@ -0,0 +1,75 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_H_
+#define _IPWIRELESS_CS_H_
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+
+#include "ipwireless_cs_hardware.h"
+
+#define IPWIRELESS_PCCARD_NAME		"ipwireless_cs"
+#define IPWIRELESS_PCMCIA_VERSION	"1.0.15-jikos2"
+#define IPWIRELESS_PCMCIA_AUTHOR        \
+	"Stephen Blackheath, Ben Martel and Jiri Kosina"
+
+#define IPWIRELESS_TX_QUEUE_SIZE  262144
+#define IPWIRELESS_RX_QUEUE_SIZE  262144
+
+#define IPWIRELESS_STATE_DEBUG
+
+struct ipw_hardware;
+struct ipw_network;
+struct ipw_tty;
+
+struct ipw_config {
+	char phone_number[129];
+};
+
+struct ipw_dev {
+	struct pcmcia_device *link;
+	int isV2Card;
+	window_handle_t handleAM;
+	void __iomem *attrMemory;
+	window_handle_t handleCM;
+	void __iomem *commonMemory;
+	dev_node_t nodes[2];
+	/* Reference to attribute memory, containing CIS data */
+	void *attribute_memory;
+
+	/* Hardware context */
+	struct ipw_hardware *hardware;
+	/* Network layer context */
+	struct ipw_network *network;
+	/* TTY device context */
+	struct ipw_tty *tty;
+	struct work_struct work_reboot;
+};
+
+/* Options configurable through the proc filesystem. */
+extern __u16 ipwireless_cs_debug;
+extern __u16 ipwireless_cs_loopback;
+extern __u16 ipwireless_cs_out_queue;
+
+#endif
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_network.c
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_network.c
@@ -0,0 +1,498 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+#include <linux/ppp_channel.h>
+#include <linux/skbuff.h>
+#include <linux/interrupt.h>
+#include <linux/netdevice.h>
+#include <linux/ppp_defs.h>
+#include <linux/if_ppp.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+
+#include "ipwireless_cs_network.h"
+#include "ipwireless_cs_hardware.h"
+#include "ipwireless_cs_main.h"
+#include "ipwireless_cs_tty.h"
+
+#define MAX_OUTGOING_PACKETS_QUEUED   ipwireless_cs_out_queue
+#define MAX_ASSOCIATED_TTYS 2
+
+#define SC_RCV_BITS     (SC_RCV_B7_1|SC_RCV_B7_0|SC_RCV_ODDP|SC_RCV_EVNP)
+
+struct ipw_network {
+	/* Hardware context, used for calls to hardware layer. */
+	struct ipw_hardware *hardware;
+	/* Context for kernel 'generic_ppp' functionality */
+	struct ppp_channel *ppp_channel;
+	/* tty context connected with IPW console */
+	struct ipw_tty *associated_ttys[NO_OF_IPW_CHANNELS][MAX_ASSOCIATED_TTYS];
+	/* True if ppp needs waking up once we're ready to xmit */
+	int ppp_blocked;
+	/* Number of packets queued up in hardware module. */
+	int outgoing_packets_queued;
+	/* Spinlock to avoid interrupts during shutdown */
+	spinlock_t spinlock;
+	struct mutex close_lock;
+
+	/* PPP ioctl data, not actually used anywere */
+	unsigned int flags;
+	unsigned int rbits;
+	u32 xaccm[8];
+	u32 raccm;
+	int mru;
+
+	int shutting_down;
+	unsigned int ras_control_lines;
+
+	struct work_struct work_go_online;
+	struct work_struct work_go_offline;
+};
+
+
+#ifdef IPWIRELESS_STATE_DEBUG
+int ipwireless_dump_network_state(char *p, struct ipw_network *network)
+{
+	int idx = 0;
+
+	idx += sprintf(p + idx, "debug: ppp_blocked=%d\n",
+			network->ppp_blocked);
+	idx += sprintf(p + idx, "debug: outgoing_packets_queued=%d\n",
+			network->outgoing_packets_queued);
+	idx += sprintf(p + idx, "debug: network.shutting_down=%d\n",
+			network->shutting_down);
+	return idx;
+}
+#endif
+
+static void notify_packet_sent(void *callback_data, unsigned int packet_length)
+{
+	struct ipw_network *network = (struct ipw_network *) callback_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	network->outgoing_packets_queued--;
+	if (network->ppp_channel != NULL) {
+		if (network->ppp_blocked) {
+			network->ppp_blocked = 0;
+			spin_unlock_irqrestore(&network->spinlock, flags);
+			ppp_output_wakeup(network->ppp_channel);
+			if (ipwireless_cs_debug)
+				printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+				       ": ppp unblocked\n");
+		} else
+			spin_unlock_irqrestore(&network->spinlock, flags);
+	} else
+		spin_unlock_irqrestore(&network->spinlock, flags);
+}
+
+/*
+ * Called by the ppp system when it has a packet to send to the hardware.
+ */
+static int ipwireless_ppp_start_xmit(struct ppp_channel *ppp_channel,
+				     struct sk_buff *skb)
+{
+	struct ipw_network *network = ppp_channel->private;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->outgoing_packets_queued < MAX_OUTGOING_PACKETS_QUEUED) {
+		unsigned char *buf;
+		static unsigned char header[] = {
+			PPP_ALLSTATIONS, /* 0xff */
+			PPP_UI,		 /* 0x03 */
+		};
+
+		network->outgoing_packets_queued++;
+		spin_unlock_irqrestore(&network->spinlock, flags);
+
+		/*
+		 * If we have the requested amount of headroom in the skb we
+		 * were handed, then we can add the header efficiently.
+		 */
+		if (skb_headroom(skb) >= 2) {
+			memcpy(skb_push(skb, 2), header, 2);
+			ipwireless_send_packet(network->hardware,
+					       IPW_CHANNEL_RAS, skb->data,
+					       skb->len,
+					       notify_packet_sent,
+					       network);
+		} else {
+			/* Otherwise (rarely) we do it inefficiently. */
+			buf = kmalloc(skb->len + 2, GFP_ATOMIC);
+			memcpy(buf + 2, skb->data, skb->len);
+			memcpy(buf, header, 2);
+			ipwireless_send_packet(network->hardware,
+					       IPW_CHANNEL_RAS, buf,
+					       skb->len + 2,
+					       notify_packet_sent,
+					       network);
+			kfree(buf);
+		}
+		kfree_skb(skb);
+		return 1;
+	} else {
+		/*
+		 * Otherwise reject the packet, and flag that the ppp system
+		 * needs to be unblocked once we are ready to send.
+		 * */
+		network->ppp_blocked = 1;
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		return 0;
+	}
+}
+
+/* Handle an ioctl call that has come in via ppp. (copy of ppp_async_ioctl() */
+static int ipwireless_ppp_ioctl(struct ppp_channel *ppp_channel,
+				unsigned int cmd, unsigned long arg)
+{
+	struct ipw_network *network = ppp_channel->private;
+	int err, val;
+	u32 accm[8];
+	int __user *user_arg = (int __user *) arg;
+
+	err = -EFAULT;
+	switch (cmd) {
+	case PPPIOCGFLAGS:
+		val = network->flags | network->rbits;
+		if (put_user(val, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSFLAGS:
+		if (get_user(val, user_arg))
+			break;
+		network->flags = val & ~SC_RCV_BITS;
+		network->rbits = val & SC_RCV_BITS;
+		err = 0;
+		break;
+
+	case PPPIOCGASYNCMAP:
+		if (put_user(network->xaccm[0], user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSASYNCMAP:
+		if (get_user(network->xaccm[0], user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCGRASYNCMAP:
+		if (put_user(network->raccm, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSRASYNCMAP:
+		if (get_user(network->raccm, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCGXASYNCMAP:
+		if (copy_to_user((void __user *) arg, network->xaccm,
+					sizeof(network->xaccm)))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSXASYNCMAP:
+		if (copy_from_user(accm, (void __user *) arg, sizeof(accm)))
+			break;
+		accm[2] &= ~0x40000000U;	/* can't escape 0x5e */
+		accm[3] |= 0x60000000U;	/* must escape 0x7d, 0x7e */
+		memcpy(network->xaccm, accm, sizeof(network->xaccm));
+		err = 0;
+		break;
+
+	case PPPIOCGMRU:
+		if (put_user(network->mru, user_arg))
+			break;
+		err = 0;
+		break;
+
+	case PPPIOCSMRU:
+		if (get_user(val, user_arg))
+			break;
+		if (val < PPP_MRU)
+			val = PPP_MRU;
+		network->mru = val;
+		err = 0;
+		break;
+
+	default:
+		err = -ENOTTY;
+	}
+
+	return err;
+}
+
+static struct ppp_channel_ops ipwireless_ppp_channel_ops = {
+	.start_xmit = ipwireless_ppp_start_xmit,
+	.ioctl      = ipwireless_ppp_ioctl
+};
+
+static void do_go_online(struct work_struct *work_go_online)
+{
+	struct ipw_network *network =
+		container_of(work_go_online, struct ipw_network,
+				work_go_online);
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (!network->ppp_channel) {
+		struct ppp_channel *channel;
+
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		channel = kzalloc(sizeof(struct ppp_channel), GFP_KERNEL);
+		channel->private = network;
+		channel->mtu = 16384;	/* Wild guess */
+		channel->hdrlen = 2;
+		channel->ops = &ipwireless_ppp_channel_ops;
+
+		network->flags = 0;
+		network->rbits = 0;
+		network->mru = PPP_MRU;
+		memset(network->xaccm, 0, sizeof(network->xaccm));
+		network->xaccm[0] = ~0U;
+		network->xaccm[3] = 0x60000000U;
+		network->raccm = ~0U;
+		ppp_register_channel(channel);
+		spin_lock_irqsave(&network->spinlock, flags);
+		network->ppp_channel = channel;
+	}
+	spin_unlock_irqrestore(&network->spinlock, flags);
+}
+
+static void do_go_offline(struct work_struct *work_go_offline)
+{
+	struct ipw_network *network =
+		container_of(work_go_offline, struct ipw_network,
+				work_go_offline);
+	unsigned long flags;
+
+	mutex_lock(&network->close_lock);
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->ppp_channel != NULL) {
+		struct ppp_channel *channel = network->ppp_channel;
+
+		network->ppp_channel = NULL;
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		mutex_unlock(&network->close_lock);
+		ppp_unregister_channel(channel);
+	} else {
+		spin_unlock_irqrestore(&network->spinlock, flags);
+		mutex_unlock(&network->close_lock);
+	}
+}
+
+void ipwireless_network_notify_control_line_change(struct ipw_network *network,
+						   unsigned int channel_idx,
+						   unsigned int control_lines,
+						   unsigned int changed_mask)
+{
+	int i;
+
+	if (channel_idx == IPW_CHANNEL_RAS)
+		network->ras_control_lines = control_lines;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++) {
+		struct ipw_tty *tty =
+			network->associated_ttys[channel_idx][i];
+
+		/*
+		 * If it's associated with a tty (other than the RAS channel
+		 * when we're online), then send the data to that tty.  The RAS
+		 * channel's data is handled above - it always goes through
+		 * ppp_generic.
+		 */
+		if (tty)
+			ipwireless_tty_notify_control_line_change(tty,
+								  channel_idx,
+								  control_lines,
+								  changed_mask);
+	}
+}
+
+/*
+ * Some versions of firmware stuff packets with 0xff 0x03 (PPP: ALLSTATIONS, UI)
+ * bytes, which are required on sent packet, but not always present on received
+ * packets
+ */
+static struct sk_buff *ipw_packet_received_skb(unsigned char *data,
+					       unsigned int length)
+{
+	struct sk_buff *skb;
+
+	if (length > 2 && data[0] == PPP_ALLSTATIONS && data[1] == PPP_UI) {
+		length -= 2;
+		data += 2;
+	}
+
+	skb = dev_alloc_skb(length + 4);
+	skb_reserve(skb, 2);
+	memcpy(skb_put(skb, length), data, length);
+
+	return skb;
+}
+
+void ipwireless_network_packet_received(struct ipw_network *network,
+					unsigned int channel_idx,
+					unsigned char *data,
+					unsigned int length)
+{
+	int i;
+	unsigned long flags;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++) {
+		struct ipw_tty *tty = network->associated_ttys[channel_idx][i];
+
+		/*
+		 * If it's associated with a tty (other than the RAS channel
+		 * when we're online), then send the data to that tty.  The RAS
+		 * channel's data is handled above - it always goes through
+		 * ppp_generic.
+		 */
+		if (tty && channel_idx == IPW_CHANNEL_RAS
+				&& (network->ras_control_lines &
+					IPW_CONTROL_LINE_DCD) != 0
+				&& ipwireless_tty_is_modem(tty)) {
+			/*
+			 * If data came in on the RAS channel and this tty is
+			 * the modem tty, and we are online, then we send it to
+			 * the PPP layer.
+			 */
+			mutex_lock(&network->close_lock);
+			spin_lock_irqsave(&network->spinlock, flags);
+			if (network->ppp_channel != NULL) {
+				struct sk_buff *skb;
+
+				spin_unlock_irqrestore(&network->spinlock,
+						flags);
+
+				/* Send the data to the ppp_generic module. */
+				skb = ipw_packet_received_skb(data, length);
+				ppp_input(network->ppp_channel, skb);
+			} else
+				spin_unlock_irqrestore(&network->spinlock,
+						flags);
+			mutex_unlock(&network->close_lock);
+		}
+		/* Otherwise we send it out the tty. */
+		else
+			ipwireless_tty_received(tty, data, length);
+	}
+}
+
+struct ipw_network *ipwireless_network_create(struct ipw_hardware *hw)
+{
+	struct ipw_network *network =
+		kzalloc(sizeof(struct ipw_network), GFP_ATOMIC);
+
+	spin_lock_init(&network->spinlock);
+	mutex_init(&network->close_lock);
+
+	network->hardware = hw;
+
+	INIT_WORK(&network->work_go_online, do_go_online);
+	INIT_WORK(&network->work_go_offline, do_go_offline);
+
+	ipwireless_associate_network(hw, network);
+
+	return network;
+}
+
+void ipwireless_network_free(struct ipw_network *network)
+{
+	network->shutting_down = 1;
+
+	ipwireless_ppp_close(network);
+	flush_scheduled_work();
+
+	ipwireless_stop_interrupts(network->hardware);
+	ipwireless_associate_network(network->hardware, NULL);
+
+	kfree(network);
+}
+
+void ipwireless_associate_network_tty(struct ipw_network *network,
+				      unsigned int channel_idx,
+				      struct ipw_tty *tty)
+{
+	int i;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++)
+		if (network->associated_ttys[channel_idx][i] == NULL) {
+			network->associated_ttys[channel_idx][i] = tty;
+			break;
+		}
+}
+
+void ipwireless_disassociate_network_ttys(struct ipw_network *network,
+					  unsigned int channel_idx)
+{
+	int i;
+
+	for (i = 0; i < MAX_ASSOCIATED_TTYS; i++)
+		network->associated_ttys[channel_idx][i] = NULL;
+}
+
+void ipwireless_ppp_open(struct ipw_network *network)
+{
+	if (ipwireless_cs_debug)
+		printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME ": online\n");
+	schedule_work(&network->work_go_online);
+}
+
+void ipwireless_ppp_close(struct ipw_network *network)
+{
+	/* Disconnect from the wireless network. */
+	if (ipwireless_cs_debug)
+		printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME ": offline\n");
+	schedule_work(&network->work_go_offline);
+}
+
+int ipwireless_ppp_channel_index(struct ipw_network *network)
+{
+	int ret = -1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->ppp_channel != NULL)
+		ret = ppp_channel_index(network->ppp_channel);
+	spin_unlock_irqrestore(&network->spinlock, flags);
+
+	return ret;
+}
+
+int ipwireless_ppp_unit_number(struct ipw_network *network)
+{
+	int ret = -1;
+	unsigned long flags;
+
+	spin_lock_irqsave(&network->spinlock, flags);
+	if (network->ppp_channel != NULL)
+		ret = ppp_unit_number(network->ppp_channel);
+	spin_unlock_irqrestore(&network->spinlock, flags);
+
+	return ret;
+}
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_network.h
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_network.h
@@ -0,0 +1,54 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_NETWORK_H_
+#define _IPWIRELESS_CS_NETWORK_H_
+
+#include <linux/types.h>
+
+struct ipw_network;
+struct ipw_tty;
+struct ipw_hardware;
+
+/* Definitions of the different channels on the PCMCIA UE */
+#define IPW_CHANNEL_RAS      0
+#define IPW_CHANNEL_DIALLER  1
+#define IPW_CHANNEL_CONSOLE  2
+#define NO_OF_IPW_CHANNELS   5
+
+void ipwireless_network_notify_control_line_change(struct ipw_network *net,
+		unsigned int channel_idx, unsigned int control_lines,
+		unsigned int control_mask);
+void ipwireless_network_packet_received(struct ipw_network *net,
+		unsigned int channel_idx, unsigned char *data,
+		unsigned int length);
+struct ipw_network *ipwireless_network_create(struct ipw_hardware *hw);
+void ipwireless_network_free(struct ipw_network *net);
+void ipwireless_associate_network_tty(struct ipw_network *net,
+		unsigned int channel_idx, struct ipw_tty *tty);
+void ipwireless_disassociate_network_ttys(struct ipw_network *net,
+		unsigned int channel_idx);
+
+void ipwireless_ppp_open(struct ipw_network *net);
+
+void ipwireless_ppp_close(struct ipw_network *net);
+int ipwireless_ppp_channel_index(struct ipw_network *net);
+int ipwireless_ppp_unit_number(struct ipw_network *net);
+
+int ipwireless_dump_network_state(char *p, struct ipw_network *net);
+
+#endif
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_setup_protocol.h
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_setup_protocol.h
@@ -0,0 +1,108 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_SETUP_PROTOCOL_H_
+#define _IPWIRELESS_CS_SETUP_PROTOCOL_H_
+
+/* Version of the setup protocol and transport protocols */
+#define TL_SETUP_VERSION		1
+
+#define TL_SETUP_VERSION_QRY_TMO	1000
+#define TL_SETUP_MAX_VERSION_QRY	30
+
+/* Message numbers 0-9 are obsoleted and must not be reused! */
+#define TL_SETUP_SIGNO_GET_VERSION_QRY	10
+#define TL_SETUP_SIGNO_GET_VERSION_RSP	11
+#define TL_SETUP_SIGNO_CONFIG_MSG	12
+#define TL_SETUP_SIGNO_CONFIG_DONE_MSG	13
+#define TL_SETUP_SIGNO_OPEN_MSG		14
+#define TL_SETUP_SIGNO_CLOSE_MSG	15
+
+#define TL_SETUP_SIGNO_INFO_MSG     20
+#define TL_SETUP_SIGNO_INFO_MSG_ACK 21
+
+#define TL_SETUP_SIGNO_REBOOT_MSG      22
+#define TL_SETUP_SIGNO_REBOOT_MSG_ACK  23
+
+/* Syncronous start-messages */
+struct TlSetupGetVersionQry {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_GET_VERSION_QRY */
+} __attribute__ ((__packed__));
+
+struct TlSetupGetVersionRsp {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_GET_VERSION_RSP */
+	unsigned char version;		/* TL_SETUP_VERSION */
+} __attribute__ ((__packed__));
+
+struct TlSetupConfigMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_CONFIG_MSG */
+	unsigned char port_no;
+	unsigned char prio_data;
+	unsigned char prio_ctrl;
+} __attribute__ ((__packed__));
+
+struct TlSetupConfigDoneMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_CONFIG_DONE_MSG */
+} __attribute__ ((__packed__));
+
+/* Asyncronous messages */
+struct TlSetupOpenMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_OPEN_MSG */
+	unsigned char port_no;
+} __attribute__ ((__packed__));
+
+struct TlSetupCloseMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_CLOSE_MSG */
+	unsigned char port_no;
+} __attribute__ ((__packed__));
+
+/* Driver type  - for use in TlSetupInfoMsg.driver_type */
+#define COMM_DRIVER     0
+#define NDISWAN_DRIVER  1
+#define NDISWAN_DRIVER_MAJOR_VERSION  2
+#define NDISWAN_DRIVER_MINOR_VERSION  0
+
+/*
+ * It should not matter when this message comes over as we just store the
+ * results and send the ACK.
+ */
+struct TlSetupInfoMsg {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_INFO_MSG */
+	unsigned char driver_type;
+	unsigned char major_version;
+	unsigned char minor_version;
+} __attribute__ ((__packed__));
+
+struct TlSetupInfoMsgAck {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_INFO_MSG_ACK */
+} __attribute__ ((__packed__));
+
+struct TlSetupRebootMsgAck {
+	unsigned char sig_no;		/* TL_SETUP_SIGNO_REBOOT_MSG_ACK */
+} __attribute__ ((__packed__));
+
+/* Define a union of all the msgs that the driver can receive from the card.*/
+union ipw_setup_rx_msg {
+	unsigned char sig_no;
+	struct TlSetupGetVersionRsp VersRspMsg;
+	struct TlSetupOpenMsg OpenMsg;
+	struct TlSetupCloseMsg CloseMsg;
+	struct TlSetupInfoMsg InfoMsg;
+	struct TlSetupInfoMsgAck InfoMsgAck;
+} __attribute__ ((__packed__));
+
+#endif				/* _IPWIRELESS_CS_SETUP_PROTOCOL_H_ */
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_tty.c
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_tty.c
@@ -0,0 +1,786 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#include <linux/autoconf.h>
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/uaccess.h>
+#include <linux/if.h>
+#include <linux/ppp_defs.h>
+#include <linux/if_ppp.h>
+#include <linux/proc_fs.h>
+#include <linux/serial.h>
+#include <linux/mutex.h>
+
+#include "ipwireless_cs_tty.h"
+#include "ipwireless_cs_network.h"
+#include "ipwireless_cs_hardware.h"
+#include "ipwireless_cs_main.h"
+
+#define IPWIRELESS_PCMCIA_START 	(0)
+#define IPWIRELESS_PCMCIA_MINORS	(24)
+#define IPWIRELESS_PCMCIA_MINOR_RANGE	(8)
+
+#define TTYTYPE_MODEM    (0)
+#define TTYTYPE_MONITOR  (1)
+#define TTYTYPE_RAS_RAW  (2)
+
+struct ipw_tty {
+	int index;
+	struct ipw_hardware *hardware;
+	unsigned int channel_idx;
+	unsigned int secondary_channel_idx;
+	int tty_type;
+	struct ipw_network *network;
+	struct tty_struct *linux_tty;
+	int open_count;
+	unsigned int control_lines;
+	struct mutex ipw_tty_mutex;
+	int tx_bytes_queued;
+	int closing;
+};
+
+static struct ipw_tty *ttys[IPWIRELESS_PCMCIA_MINORS];
+
+static struct tty_driver *ipw_tty_driver;
+
+static char *tty_type_name(int tty_type)
+{
+	static char *channel_names[] = {
+		"modem",
+		"monitor",
+		"RAS-raw"
+	};
+
+	return channel_names[tty_type];
+}
+
+static void report_registering(struct ipw_tty *tty)
+{
+	char *iftype = tty_type_name(tty->tty_type);
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+	       ": registering %s device ttyIPWp%d\n", iftype, tty->index);
+}
+
+static void report_deregistering(struct ipw_tty *tty)
+{
+	char *iftype = tty_type_name(tty->tty_type);
+
+	printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+	       ": deregistering %s device ttyIPWp%d\n", iftype,
+	       tty->index);
+}
+
+static struct ipw_tty *get_tty(int minor)
+{
+	if (minor < IPWIRELESS_PCMCIA_START
+			|| minor >= IPWIRELESS_PCMCIA_START +
+			IPWIRELESS_PCMCIA_MINORS)
+		return NULL;
+	else {
+		int minor_offset = minor - IPWIRELESS_PCMCIA_START;
+
+		/*
+		 * The 'ras_raw' channel is only available when 'loopback' mode
+		 * is enabled.
+		 * Number of minor starts with 16 (_RANGE * _RAS_RAW).
+		 */
+		if (!ipwireless_cs_loopback &&
+				minor_offset >=
+				 IPWIRELESS_PCMCIA_MINOR_RANGE * TTYTYPE_RAS_RAW)
+			return NULL;
+
+		return ttys[minor_offset];
+	}
+}
+
+static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
+{
+	int minor = linux_tty->index;
+	struct ipw_tty *tty = get_tty(minor);
+
+	if (!tty)
+		return -ENODEV;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+
+	if (tty->closing) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return -ENODEV;
+	}
+	if (tty->open_count == 0)
+		tty->tx_bytes_queued = 0;
+
+	tty->open_count++;
+
+	tty->linux_tty = linux_tty;
+	linux_tty->driver_data = tty;
+	linux_tty->low_latency = 1;
+
+	if (tty->tty_type == TTYTYPE_MODEM)
+		ipwireless_ppp_open(tty->network);
+
+	mutex_unlock(&tty->ipw_tty_mutex);
+
+	return 0;
+}
+
+static void do_ipw_close(struct ipw_tty *tty)
+{
+	tty->open_count--;
+
+	if (tty->open_count == 0) {
+		struct tty_struct *linux_tty = tty->linux_tty;
+
+		if (linux_tty != NULL) {
+			tty->linux_tty = NULL;
+			linux_tty->driver_data = NULL;
+
+			if (tty->tty_type == TTYTYPE_MODEM)
+				ipwireless_ppp_close(tty->network);
+		}
+	}
+}
+
+static void ipw_hangup(struct tty_struct *linux_tty)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+	if (tty->open_count == 0) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return;
+	}
+
+	do_ipw_close(tty);
+
+	mutex_unlock(&tty->ipw_tty_mutex);
+}
+
+static void ipw_close(struct tty_struct *linux_tty, struct file *filp)
+{
+	ipw_hangup(linux_tty);
+}
+
+/* Take data received from hardware, and send it out the tty */
+void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
+			unsigned int length)
+{
+	struct tty_struct *linux_tty;
+	int work = 0;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+	linux_tty = tty->linux_tty;
+	if (linux_tty == NULL) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return;
+	}
+
+	if (!tty->open_count) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return;
+	}
+	mutex_unlock(&tty->ipw_tty_mutex);
+
+	work = tty_insert_flip_string(linux_tty, data, length);
+
+	if (work != length)
+		printk(KERN_DEBUG "%d chars not inserted to flip buffer!\n",
+				length - work);
+
+	/*
+	 * This may sleep if ->low_latency is set
+	 */
+	if (work)
+		tty_flip_buffer_push(linux_tty);
+}
+
+static void ipw_write_packet_sent_callback(void *callback_data,
+					   unsigned int packet_length)
+{
+	struct ipw_tty *tty = (struct ipw_tty *) callback_data;
+
+	/*
+	 * Packet has been sent, so we subtract the number of bytes from our
+	 * tally of outstanding TX bytes.
+	 */
+	tty->tx_bytes_queued -= packet_length;
+}
+
+static int ipw_write(struct tty_struct *linux_tty,
+		     const unsigned char *buf, int count)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+	int room;
+
+	if (!tty)
+		return -ENODEV;
+
+	mutex_lock(&tty->ipw_tty_mutex);
+	if (!tty->open_count) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return -EINVAL;
+	}
+
+	room = IPWIRELESS_TX_QUEUE_SIZE - tty->tx_bytes_queued;
+	if (room < 0)
+		room = 0;
+	/* Don't allow caller to write any more than we have room for */
+	if (count > room)
+		count = room;
+
+	if (count == 0) {
+		mutex_unlock(&tty->ipw_tty_mutex);
+		return 0;
+	}
+
+	tty->tx_bytes_queued += count;
+	ipwireless_send_packet(tty->hardware, IPW_CHANNEL_RAS,
+			       (unsigned char *) buf, count,
+			       ipw_write_packet_sent_callback, tty);
+	mutex_unlock(&tty->ipw_tty_mutex);
+
+	return count;
+}
+
+static int ipw_write_room(struct tty_struct *linux_tty)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+	int room;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	room = IPWIRELESS_TX_QUEUE_SIZE - tty->tx_bytes_queued;
+	if (room < 0)
+		room = 0;
+
+	return room;
+}
+
+static int ipwireless_get_serial_info(struct ipw_tty *tty,
+				      struct serial_struct __user *retinfo)
+{
+	struct serial_struct tmp;
+
+	if (!retinfo)
+		return (-EFAULT);
+
+	memset(&tmp, 0, sizeof(tmp));
+	tmp.type = PORT_UNKNOWN;
+	tmp.line = tty->index;
+	tmp.port = 0;
+	tmp.irq = 0;
+	tmp.flags = 0;
+	tmp.baud_base = 115200;
+	tmp.close_delay = 0;
+	tmp.closing_wait = 0;
+	tmp.custom_divisor = 0;
+	tmp.hub6 = 0;
+	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int ipw_chars_in_buffer(struct tty_struct *linux_tty)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	return tty->tx_bytes_queued;
+}
+
+static int get_control_lines(struct ipw_tty *tty)
+{
+	unsigned int my = tty->control_lines;
+	unsigned int out = 0;
+
+	if (my & IPW_CONTROL_LINE_RTS)
+		out |= TIOCM_RTS;
+	if (my & IPW_CONTROL_LINE_DTR)
+		out |= TIOCM_DTR;
+	if (my & IPW_CONTROL_LINE_CTS)
+		out |= TIOCM_CTS;
+	if (my & IPW_CONTROL_LINE_DSR)
+		out |= TIOCM_DSR;
+	if (my & IPW_CONTROL_LINE_DCD)
+		out |= TIOCM_CD;
+
+	return out;
+}
+
+static int set_control_lines(struct ipw_tty *tty, unsigned int set,
+			     unsigned int clear)
+{
+	if (set & TIOCM_RTS) {
+		ipwireless_set_RTS(tty->hardware, tty->channel_idx, 1);
+		if (tty->secondary_channel_idx != -1)
+			ipwireless_set_RTS(tty->hardware,
+					  tty->secondary_channel_idx, 1);
+	}
+	if (set & TIOCM_DTR) {
+		ipwireless_set_DTR(tty->hardware, tty->channel_idx, 1);
+		if (tty->secondary_channel_idx != -1)
+			ipwireless_set_DTR(tty->hardware,
+					  tty->secondary_channel_idx, 1);
+	}
+	if (clear & TIOCM_RTS) {
+		ipwireless_set_RTS(tty->hardware, tty->channel_idx, 0);
+		if (tty->secondary_channel_idx != -1)
+			ipwireless_set_RTS(tty->hardware,
+					  tty->secondary_channel_idx, 0);
+	}
+	if (clear & TIOCM_DTR) {
+		ipwireless_set_DTR(tty->hardware, tty->channel_idx, 0);
+		if (tty->secondary_channel_idx != -1)
+			ipwireless_set_DTR(tty->hardware,
+					  tty->secondary_channel_idx, 0);
+	}
+	return 0;
+}
+
+static int ipw_tiocmget(struct tty_struct *linux_tty, struct file *file)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	return get_control_lines(tty);
+}
+
+static int
+ipw_tiocmset(struct tty_struct *linux_tty, struct file *file,
+	     unsigned int set, unsigned int clear)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	return set_control_lines(tty, set, clear);
+}
+
+static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
+		     unsigned int cmd, unsigned long arg)
+{
+	struct ipw_tty *tty = linux_tty->driver_data;
+
+	if (!tty)
+		return -ENODEV;
+
+	if (!tty->open_count)
+		return -EINVAL;
+
+	switch (cmd) {
+	case TIOCGSERIAL:
+		return ipwireless_get_serial_info(tty, (void __user *) arg);
+
+	case TIOCSSERIAL:
+		return 0;	/* Keeps the PCMCIA scripts happy. */
+	}
+
+	if (tty->tty_type == TTYTYPE_MODEM) {
+		switch (cmd) {
+		case PPPIOCGCHAN:
+			{
+				int chan = ipwireless_ppp_channel_index(
+							tty->network);
+
+				if (chan < 0)
+					return -ENODEV;
+				if (put_user(chan, (int __user *) arg))
+					return -EFAULT;
+			}
+			return 0;
+
+		case PPPIOCGUNIT:
+			{
+				int unit = ipwireless_ppp_unit_number(
+						tty->network);
+
+				if (unit < 0)
+					return -ENODEV;
+				if (put_user(unit, (int __user *) arg))
+					return -EFAULT;
+			}
+			return 0;
+
+		case TCGETS:
+		case TCGETA:
+			return n_tty_ioctl(linux_tty, file, cmd, arg);
+
+		case TCFLSH:
+			return n_tty_ioctl(linux_tty, file, cmd, arg);
+
+		case FIONREAD:
+			{
+				int val = 0;
+
+				if (put_user(val, (int __user *) arg))
+					return -EFAULT;
+			}
+			return 0;
+		}
+	}
+
+	return -ENOIOCTLCMD;
+}
+
+static void add_tty(dev_node_t *nodesp, int j,
+		    struct ipw_hardware *hardware,
+		    struct ipw_network *network, int channel_idx,
+		    int secondary_channel_idx, int tty_type)
+{
+	ttys[j] = kzalloc(sizeof(struct ipw_tty), GFP_KERNEL);
+	ttys[j]->index = j;
+	ttys[j]->hardware = hardware;
+	ttys[j]->channel_idx = channel_idx;
+	ttys[j]->secondary_channel_idx = secondary_channel_idx;
+	ttys[j]->network = network;
+	ttys[j]->tty_type = tty_type;
+	mutex_init(&ttys[j]->ipw_tty_mutex);
+
+	ipwireless_associate_network_tty(network, channel_idx, ttys[j]);
+
+	if (secondary_channel_idx != -1)
+		ipwireless_associate_network_tty(network,
+						 secondary_channel_idx,
+						 ttys[j]);
+	if (nodesp != NULL) {
+		sprintf(nodesp->dev_name, "ttyIPWp%d", j);
+		nodesp->major = ipw_tty_driver->major;
+		nodesp->minor = j + IPWIRELESS_PCMCIA_START;
+	}
+	if (get_tty(j + IPWIRELESS_PCMCIA_START) == ttys[j])
+		report_registering(ttys[j]);
+}
+
+struct ipw_tty *ipwireless_tty_create(struct ipw_hardware *hardware,
+				      struct ipw_network *network,
+				      dev_node_t *nodes)
+{
+	int i, j;
+
+	for (i = 0; i < IPWIRELESS_PCMCIA_MINOR_RANGE; i++) {
+		int allfree = 1;
+
+		for (j = i; j < IPWIRELESS_PCMCIA_MINORS;
+				j += IPWIRELESS_PCMCIA_MINOR_RANGE)
+			if (ttys[j] != NULL) {
+				allfree = 0;
+				break;
+			}
+
+		if (allfree) {
+			j = i;
+
+			add_tty(&nodes[0], j, hardware, network,
+				IPW_CHANNEL_DIALLER, IPW_CHANNEL_RAS,
+				TTYTYPE_MODEM);
+			j += IPWIRELESS_PCMCIA_MINOR_RANGE;
+			add_tty(&nodes[1], j, hardware, network,
+				IPW_CHANNEL_DIALLER, -1, TTYTYPE_MONITOR);
+			j += IPWIRELESS_PCMCIA_MINOR_RANGE;
+			add_tty(NULL, j, hardware, network,
+				IPW_CHANNEL_RAS, -1, TTYTYPE_RAS_RAW);
+
+			nodes[0].next = &nodes[1];
+			nodes[1].next = NULL;
+
+			return ttys[i];
+		}
+	}
+	return NULL;
+}
+
+/*!
+ * Must be called before ipwireless_network_free().
+ */
+void ipwireless_tty_free(struct ipw_tty *tty)
+{
+	int j;
+	struct ipw_network *network = ttys[tty->index]->network;
+
+	for (j = tty->index; j < IPWIRELESS_PCMCIA_MINORS;
+			j += IPWIRELESS_PCMCIA_MINOR_RANGE) {
+		struct ipw_tty *ttyj = ttys[j];
+
+		if (ttyj) {
+			mutex_lock(&ttyj->ipw_tty_mutex);
+			if (get_tty(j + IPWIRELESS_PCMCIA_START) == ttyj)
+				report_deregistering(ttyj);
+			ttyj->closing = 1;
+			if (ttyj->linux_tty != NULL) {
+				mutex_unlock(&ttyj->ipw_tty_mutex);
+				tty_hangup(ttyj->linux_tty);
+				/* Wait till the tty_hangup has completed */
+				flush_scheduled_work();
+				mutex_lock(&ttyj->ipw_tty_mutex);
+			}
+			while (ttyj->open_count)
+				do_ipw_close(ttyj);
+			ipwireless_disassociate_network_ttys(network,
+							     ttyj->channel_idx);
+			ttys[j] = NULL;
+			mutex_unlock(&ttyj->ipw_tty_mutex);
+			kfree(ttyj);
+		}
+	}
+}
+
+static struct tty_operations tty_ops = {
+	.open = ipw_open,
+	.close = ipw_close,
+	.hangup = ipw_hangup,
+	.write = ipw_write,
+	.write_room = ipw_write_room,
+	.ioctl = ipw_ioctl,
+	.chars_in_buffer = ipw_chars_in_buffer,
+	.tiocmget = ipw_tiocmget,
+	.tiocmset = ipw_tiocmset,
+};
+
+static int proc_read(char *page, char **start, off_t off, int count,
+		     int *eof, void *data)
+{
+	int i, j;
+	char *p = page;
+	int len;
+
+	if (off == 0) {
+		p += sprintf(p, "driver: %s\nversion: %s\n\n",
+			     IPWIRELESS_PCCARD_NAME,
+			     IPWIRELESS_PCMCIA_VERSION);
+		for (i = 0; i < IPWIRELESS_PCMCIA_MINOR_RANGE; i++)
+			for (j = i; j < IPWIRELESS_PCMCIA_MINORS;
+					j += IPWIRELESS_PCMCIA_MINOR_RANGE)
+				if (ttys[j] != NULL &&
+						get_tty(ttys[j]->index +
+							IPWIRELESS_PCMCIA_START)
+							== ttys[j])
+					p += sprintf(p, "port: /dev/ttyIPWp%d %s %d\n",
+							j,
+							tty_type_name(ttys[j]->tty_type),
+							ttys[j]->open_count);
+#ifdef IPWIRELESS_STATE_DEBUG
+		*p++ = '\n';
+		for (i = 0; i < IPWIRELESS_PCMCIA_MINOR_RANGE; i++)
+			if (ttys[i] != NULL) {
+				p += ipwireless_dump_hardware_state(p,
+						ttys[i]->hardware);
+				if (ttys[i]->network != NULL)
+					p += ipwireless_dump_network_state(p,
+							ttys[i]->network);
+				break;
+			}
+#endif
+	}
+
+	len = (p - page);
+	if (len <= off + count)
+		*eof = 1;
+	*start = page + off;
+	len -= off;
+	if (len > count)
+		len = count;
+	if (len < 0)
+		len = 0;
+
+	return len;
+}
+
+static int proc_write(struct file *file, const char __user *buffer,
+		      unsigned long count, void *data)
+{
+	char *command = kmalloc(count + 1, GFP_KERNEL);
+	int i, lineLen;
+	struct ipw_tty *could_open[IPWIRELESS_PCMCIA_MINORS];
+
+	if (copy_from_user(command, buffer, count)) {
+		kfree(command);
+		return -EFAULT;
+	}
+	command[count] = '\0';
+
+	for (i = 0; i < IPWIRELESS_PCMCIA_MINORS; ++i)
+		could_open[i] = get_tty(i + IPWIRELESS_PCMCIA_START);
+
+	for (i = 0; i < count; i += lineLen + 1) {
+		char *cmd;
+
+		lineLen = 0;
+		while (command[i + lineLen] != '\n'
+				&& command[i + lineLen] != '\0')
+			lineLen++;
+		command[i + lineLen] = '\0';
+
+		cmd = command + i;
+
+		if (strncmp(cmd, "debug=", 6) == 0) {
+			ipwireless_cs_debug =
+			    (int) simple_strtol(cmd + 6, NULL, 10);
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": set debug=%d\n", ipwireless_cs_debug);
+		} else if (strncmp(cmd, "loopback=", 9) == 0) {
+			ipwireless_cs_loopback =
+			    (int) simple_strtol(cmd + 9, NULL, 10);
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": set loopback=%d\n",
+			       ipwireless_cs_loopback);
+		} else if (strncmp(cmd, "out_queue=", 10) == 0) {
+			ipwireless_cs_out_queue =
+			    (int) simple_strtol(cmd + 10, NULL, 10);
+			printk(KERN_INFO IPWIRELESS_PCCARD_NAME
+			       ": set out_queue=%d\n",
+			       ipwireless_cs_out_queue);
+		}
+	}
+	kfree(command);
+
+	/* Report any created or destroyed ttys */
+	for (i = 0; i < IPWIRELESS_PCMCIA_MINORS; ++i) {
+		struct ipw_tty *can_open = get_tty(i + IPWIRELESS_PCMCIA_START);
+
+		if (can_open && !could_open[i])
+			report_registering(can_open);
+		if (!can_open && could_open[i])
+			report_deregistering(could_open[i]);
+	}
+	return count;
+}
+
+int ipwireless_tty_init(int major)
+{
+	int result;
+
+	ipw_tty_driver = alloc_tty_driver(IPWIRELESS_PCMCIA_MINORS);
+	if (!ipw_tty_driver)
+		return -ENOMEM;
+
+	ipw_tty_driver->owner = THIS_MODULE;
+	ipw_tty_driver->driver_name = IPWIRELESS_PCCARD_NAME;
+	ipw_tty_driver->name = "ttyIPWp";
+	ipw_tty_driver->major = major;
+	ipw_tty_driver->minor_start = IPWIRELESS_PCMCIA_START;
+	ipw_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	ipw_tty_driver->subtype = SERIAL_TYPE_NORMAL;
+	ipw_tty_driver->flags = TTY_DRIVER_REAL_RAW;
+	ipw_tty_driver->init_termios = tty_std_termios;
+	ipw_tty_driver->init_termios.c_cflag =
+	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty_set_operations(ipw_tty_driver, &tty_ops);
+	result = tty_register_driver(ipw_tty_driver);
+	if (result) {
+		printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+		       ": failed to register tty driver\n");
+		put_tty_driver(ipw_tty_driver);
+		return result;
+	}
+
+	{
+		struct proc_dir_entry *proc_ent;
+
+		proc_ent =
+		    create_proc_entry(IPWIRELESS_PCCARD_NAME,
+				      S_IRUGO | S_IWUSR | S_IWGRP,
+				      &proc_root);
+		if (proc_ent != NULL) {
+			proc_ent->read_proc = proc_read;
+			proc_ent->write_proc = proc_write;
+		}
+	}
+
+	return 0;
+}
+
+void ipwireless_tty_release(void)
+{
+	int ret, loops = 0;
+
+	remove_proc_entry(IPWIRELESS_PCCARD_NAME, &proc_root);
+
+	while (1) {
+		ret = tty_unregister_driver(ipw_tty_driver);
+		put_tty_driver(ipw_tty_driver);
+		if (ret != 0) {
+			if (loops == 0)
+				printk(KERN_ERR IPWIRELESS_PCCARD_NAME
+				       ": tty_unregister_driver failed %d - "
+				       "retrying...\n", ret);
+		} else
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ / 5);
+		loops++;
+	}
+}
+
+int ipwireless_tty_is_modem(struct ipw_tty *tty)
+{
+	return tty->tty_type == TTYTYPE_MODEM;
+}
+
+void
+ipwireless_tty_notify_control_line_change(struct ipw_tty *tty,
+					  unsigned int channel_idx,
+					  unsigned int control_lines,
+					  unsigned int changed_mask)
+{
+	unsigned int old_control_lines = tty->control_lines;
+
+	tty->control_lines = (tty->control_lines & ~changed_mask)
+		| (control_lines & changed_mask);
+
+	/*
+	 * If DCD is de-asserted, we close the tty so pppd can tell that we
+	 * have gone offline.
+	 */
+	if ((old_control_lines & IPW_CONTROL_LINE_DCD)
+			&& !(tty->control_lines & IPW_CONTROL_LINE_DCD)
+			&& tty->linux_tty) {
+		tty_hangup(tty->linux_tty);
+	}
+}
+
diff -puN /dev/null drivers/char/pcmcia/ipwireless_cs_tty.h
--- /dev/null
+++ a/drivers/char/pcmcia/ipwireless_cs_tty.h
@@ -0,0 +1,48 @@
+/*
+ * IPWireless 3G PCMCIA Network Driver
+ *
+ * Original code
+ *   by Stephen Blackheath <stephen@blacksapphire.com>,
+ *      Ben Martel <benm@symmetric.co.nz>
+ *
+ * Copyrighted as follows:
+ *   Copyright (C) 2004 by Symmetric Systems Ltd (NZ)
+ *
+ * Various driver changes and rewrites, port to new kernels
+ *   Copyright (C) 2006-2007 Jiri Kosina
+ *
+ * Misc code cleanups and updates
+ *   Copyright (C) 2007 David Sterba
+ */
+
+#ifndef _IPWIRELESS_CS_TTY_H_
+#define _IPWIRELESS_CS_TTY_H_
+
+#include <linux/types.h>
+#include <linux/sched.h>
+
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+
+struct ipw_tty;
+struct ipw_network;
+struct ipw_hardware;
+
+int ipwireless_tty_init(int);
+
+void ipwireless_tty_release(void);
+
+struct ipw_tty *ipwireless_tty_create(struct ipw_hardware *hw,
+				      struct ipw_network *net,
+				      dev_node_t *nodes);
+void ipwireless_tty_free(struct ipw_tty *tty);
+void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
+		unsigned int length);
+int ipwireless_tty_is_modem(struct ipw_tty *tty);
+void ipwireless_tty_notify_control_line_change(struct ipw_tty *tty,
+		unsigned int channel_idx, unsigned int control_lines,
+		unsigned int changed_mask);
+
+#endif
_

Patches currently in -mm which might be from dsterba@suse.cz are

git-ipwireless_cs.patch
