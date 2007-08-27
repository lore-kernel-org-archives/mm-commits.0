From: akpm@linux-foundation.org
Subject: + nfsv4-fix-a-typo-in-_nfs4_do_open_reclaim.patch added to -mm tree
Date: Mon, 27 Aug 2007 16:04:37 -0700
Message-ID: <200708272304.l7RN4bS2000756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbXH0XGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 19:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trond.myklebust@fys.uio.no, Trond.Myklebust@netapp.com


The patch titled
     NFSv4: Fix a typo in _nfs4_do_open_reclaim
has been added to the -mm tree.  Its filename is
     nfsv4-fix-a-typo-in-_nfs4_do_open_reclaim.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFSv4: Fix a typo in _nfs4_do_open_reclaim
From: Trond Myklebust <trond.myklebust@fys.uio.no>

This should fix the following Oops reported by Jeff Garzik:

kernel BUG at fs/nfs/nfs4xdr.c:1040!
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in: nfs lockd sunrpc af_packet
ipv6 cpufreq_ondemand acpi_cpufreq battery floppy nvram sg snd_hda_intel
ata_generic snd_pcm_oss snd_mixer_oss snd_pcm i2c_i801 snd_page_alloc e1000
firewire_ohci ata_piix i2c_core sr_mod cdrom sata_sil ahci libata sd_mod
scsi_mod ext3 jbd ehci_hcd uhci_hcd
Pid: 16353, comm: 10.10.10.1-recl Not tainted 2.6.23-rc3 #1
RIP: 0010:[<ffffffff88240980>] [<ffffffff88240980>] :nfs:encode_open+0x1c0/0x330
RSP: 0018:ffff8100467c5c60  EFLAGS: 00010202
RAX: ffff81000f89b8b8 RBX: 00000000697a6f6d RCX: ffff81000f89b8b8
RDX: 0000000000000004 RSI: 0000000000000004 RDI: ffff8100467c5c80
RBP: ffff8100467c5c80 R08: ffff81000f89bc30 R09: ffff81000f89b83f
R10: 0000000000000001 R11: ffffffff881e79e0 R12: ffff81003cbd1808
R13: ffff81000f89b860 R14: ffff81005fc984e0 R15: ffffffff88240af0
FS:  0000000000000000(0000) GS:ffffffff8052a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002adb9e51a030 CR3: 000000007ea7e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process 10.10.10.1-recl (pid: 16353, threadinfo ffff8100467c4000, task ffff8100038ce780)
Stack:  ffff81004aeb6a40 ffff81003cbd1808 ffff81003cbd1808 ffffffff88240b5d
 ffff81000f89b8bc ffff81005fc984e8 ffff81000f89bc30 ffff81005fc984e8
 0000000300000000 0000000000000000 0000000000000000 ffff81003cbd1800
Call Trace:
 [<ffffffff88240b5d>] :nfs:nfs4_xdr_enc_open_noattr+0x6d/0x90
 [<ffffffff881e74b7>] :sunrpc:rpcauth_wrap_req+0x97/0xf0
 [<ffffffff88240af0>] :nfs:nfs4_xdr_enc_open_noattr+0x0/0x90
 [<ffffffff881df57a>] :sunrpc:call_transmit+0x18a/0x290
 [<ffffffff881e5e7b>] :sunrpc:__rpc_execute+0x6b/0x290
 [<ffffffff881dff76>] :sunrpc:rpc_do_run_task+0x76/0xd0
 [<ffffffff882373f6>] :nfs:_nfs4_proc_open+0x76/0x230
 [<ffffffff88237a2e>] :nfs:nfs4_open_recover_helper+0x5e/0xc0
 [<ffffffff88237b74>] :nfs:nfs4_open_recover+0xe4/0x120
 [<ffffffff88238e14>] :nfs:nfs4_open_reclaim+0xa4/0xf0
 [<ffffffff882413c5>] :nfs:nfs4_reclaim_open_state+0x55/0x1b0
 [<ffffffff882417ea>] :nfs:reclaimer+0x2ca/0x390
 [<ffffffff88241520>] :nfs:reclaimer+0x0/0x390
 [<ffffffff8024e59b>] kthread+0x4b/0x80
 [<ffffffff8020cad8>] child_rip+0xa/0x12
 [<ffffffff8024e550>] kthread+0x0/0x80
 [<ffffffff8020cace>] child_rip+0x0/0x12

Code: 0f 0b eb fe 48 89 ef c7 00 00 00 00 02 be 08 00 00 00 e8 79
RIP  [<ffffffff88240980>] :nfs:encode_open+0x1c0/0x330
 RSP <ffff8100467c5c60>

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4proc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/nfs4proc.c~nfsv4-fix-a-typo-in-_nfs4_do_open_reclaim fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~nfsv4-fix-a-typo-in-_nfs4_do_open_reclaim
+++ a/fs/nfs/nfs4proc.c
@@ -646,7 +646,7 @@ static int _nfs4_do_open_reclaim(struct 
 	rcu_read_lock();
 	delegation = rcu_dereference(NFS_I(state->inode)->delegation);
 	if (delegation != NULL && (delegation->flags & NFS_DELEGATION_NEED_RECLAIM) != 0)
-		delegation_type = delegation->flags;
+		delegation_type = delegation->type;
 	rcu_read_unlock();
 	opendata->o_arg.u.delegation_type = delegation_type;
 	status = nfs4_open_recover(opendata, state);
_

Patches currently in -mm which might be from trond.myklebust@fys.uio.no are

git-nfs-vs-git-unionfs.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
nfs-fix-oops-re-sysctls-and-v4-support.patch
nfsv4-fix-a-typo-in-_nfs4_do_open_reclaim.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
file-capabilities-clear-fcaps-on-inode-change.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
