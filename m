From: akpm@linux-foundation.org
Subject: + generic_file_splice_read-fix-lockups.patch added to -mm tree
Date: Wed, 09 Apr 2008 11:57:24 -0700
Message-ID: <200804091857.m39IvOs1025106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756675AbYDIS6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 14:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens.axboe@oracle.com, allard@byte.nl, miklos@szeredi.hu, neilb@suse.de


The patch titled
     generic_file_splice_read(): fix lockups
has been added to the -mm tree.  Its filename is
     generic_file_splice_read-fix-lockups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic_file_splice_read(): fix lockups
From: Jens Axboe <jens.axboe@oracle.com>

On Thu, Feb 28 2008, Andrew Morton wrote:
> On Thu, 28 Feb 2008 15:04:12 +0100 (CET) Allard Hoeve <allard@byte.nl> wrote:
>
> >
> > Hello all,
> >
> > The last few days our trusty NFS server has experienced several soft
> > lockups. These occur every 11 hours or so. The system does not respond
> > afterwards. Sending sysrq commands over the serial console seems to work
> > allthough we had to powercycle the server once.
> >
> > First we thought it would be an NFS problem, and now that we tried
> > 2.6.23.17 instead of 2.6.24.2, we now have two different stacktraces that
> > share a trace through nfsd (nfsd_direct_splice_actor):
> >
> > http://article.gmane.org/gmane.linux.nfs/19107
>
> This:
>
> BUG: soft lockup - CPU#0 stuck for 11s! [nfsd:2716]
>
> Pid: 2716, comm: nfsd Not tainted (2.6.24.2-fwsh-byte #2)
> EIP: 0060:[<c0140967>] EFLAGS: 00000286 CPU: 0
> EIP is at find_get_pages_contig+0x67/0x73
> EAX: 00000000 EBX: 00000001 ECX: c25cc520 EDX: c25cc520
> ESI: 00000078 EDI: ca2fbdbc EBP: 00000001 ESP: dffb5c6c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b7f5d000 CR3: 1fc45000 CR4: 000006f0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c017c49c>] __generic_file_splice_read+0xa2/0x41e
>  [<c0113b11>] sched_slice+0x15/0x6f
>  [<c0131291>] getnstimeofday+0x31/0x105
>  [<c0134301>] clockevents_program_event+0xbf/0x134
>  [<c012ef49>] ktime_get_ts+0x15/0x47
>  [<c01231ea>] run_timer_softirq+0x30/0x184
>  [<c012a893>] __rcu_process_callbacks+0x76/0xbb
>  [<c011f979>] tasklet_action+0x53/0x93
>  [<c011f754>] __do_softirq+0xba/0xcf
>  [<c010e20e>] smp_apic_timer_interrupt+0x2c/0x35
>  [<c01032e0>] apic_timer_interrupt+0x28/0x30
>  [<c017c88d>] generic_file_splice_read+0x75/0xc9
>  [<c017d083>] do_splice_to+0x6e/0x90
>  [<c017d144>] splice_direct_to_actor+0x9f/0x166
>  [<f8f2cf72>] nfsd_direct_splice_actor+0x0/0xa [nfsd]
>  [<c017c818>] generic_file_splice_read+0x0/0xc9
>  [<f8f2d309>] nfsd_vfs_read+0x38d/0x3b1 [nfsd]
>  [<f8f2b3b8>] nfsd_acceptable+0x0/0xd1 [nfsd]
>  [<c016014f>] dentry_open+0x34/0x64
>  [<f8f2d73c>] nfsd_read+0xee/0xfb [nfsd]
>  [<f8f33b8b>] nfsd3_proc_read+0xfe/0x186 [nfsd]
>  [<f8f354cb>] nfs3svc_decode_readargs+0x0/0xeb [nfsd]
>  [<f8f29855>] nfsd_dispatch+0xc5/0x1ac [nfsd]
>  [<c0445ab2>] svcauth_unix_set_client+0x116/0x165
>  [<c0441ad1>] svc_process+0x4e9/0x6b4
>  [<c01168e2>] default_wake_function+0x0/0x8
>  [<f8f2963d>] nfsd+0x16a/0x290 [nfsd]
>  [<f8f294d3>] nfsd+0x0/0x290 [nfsd]
>  [<c0103463>] kernel_thread_helper+0x7/0x10
>  =======================
>
> > http://article.gmane.org/gmane.linux.nfs/19130
> >
> > The second however, leads me to think the (relatively new) scheduler might
> > be involved through __check_preempt_curr_fair.
>
> Nope, it looks like the splice code got stuck
>
> > I'm now trying 2.6.22.19, which has a recent lockd issue with NFS fixed
> > but hasn't had the scheduler update.
> >
> > How do I go about debugging this problem? What do you experts think?
>
> This ex-expert has real worries about generic_file_splice_read().  For
> starters, if __generic_file_splice_read() decides to return zero all the
> time, that function will lock up.
>
> Anyway.  Jens, I think we have a splice problem here.

I agree, that loop has been a point of contention before. So this is how
I would fix it - never repeat a __generic_file_splice_read(), just pass
back the short splice. And make __generic_file_splice_read() pass back
-EAGAIN correctly. diffstat is good, too :-)

Does this work?

Cc: Allard Hoeve <allard@byte.nl>
Cc: Neil Brown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff -puN fs/splice.c~generic_file_splice_read-fix-lockups fs/splice.c
--- a/fs/splice.c~generic_file_splice_read-fix-lockups
+++ a/fs/splice.c
@@ -370,8 +370,10 @@ __generic_file_splice_read(struct file *
 			 * for an in-flight io page
 			 */
 			if (flags & SPLICE_F_NONBLOCK) {
-				if (TestSetPageLocked(page))
+				if (TestSetPageLocked(page)) {
+					error = -EAGAIN;
 					break;
+				}
 			} else
 				lock_page(page);
 
@@ -479,9 +481,8 @@ ssize_t generic_file_splice_read(struct 
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags)
 {
-	ssize_t spliced;
-	int ret;
 	loff_t isize, left;
+	int ret;
 
 	isize = i_size_read(in->f_mapping->host);
 	if (unlikely(*ppos >= isize))
@@ -491,29 +492,9 @@ ssize_t generic_file_splice_read(struct 
 	if (unlikely(left < len))
 		len = left;
 
-	ret = 0;
-	spliced = 0;
-	while (len && !spliced) {
-		ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
-
-		if (ret < 0)
-			break;
-		else if (!ret) {
-			if (spliced)
-				break;
-			if (flags & SPLICE_F_NONBLOCK) {
-				ret = -EAGAIN;
-				break;
-			}
-		}
-
+	ret = __generic_file_splice_read(in, ppos, pipe, len, flags);
+	if (ret > 0)
 		*ppos += ret;
-		len -= ret;
-		spliced += ret;
-	}
-
-	if (spliced)
-		return spliced;
 
 	return ret;
 }
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

origin.patch
generic_file_splice_read-fix-lockups.patch
revert-set-relay-file-can-not-be-read-by-pread2.patch
git-powerpc.patch
git-scsi-misc.patch
git-block.patch
git-block-git-rejects.patch
kconfig-cleanup-block-kconfig-help-descriptions.patch
kconfig-cleanup-block-kconfigiosched-help-descriptions.patch
block-replace-remaining-__function__-occurrences.patch
block-fix-memory-hotplug-and-bouncing-in-block-layer.patch
cfq-iosched-do-not-leak-ioc_data-across-iosched-switches.patch
xen-make-blkif_getgeo-static.patch
modify-ramdisk-brd-device-to-be-able-to-manage-partitions.patch
block-remove-remaining-__function__-occurances.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
reiser4-specify-splice-file-operations.patch

