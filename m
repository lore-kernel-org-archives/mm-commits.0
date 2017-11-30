From: akpm@linux-foundation.org
Subject: [patch 18/28] Revert "mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical"
Date: Wed, 29 Nov 2017 16:10:58 -0800
Message-ID: <5a1f4c92.O70SJ4usTYNNHEuo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60728 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753580AbdK3ALA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, jack@suse.cz, laoar.shao@gmail.com, penguin-kernel@I-love.SAKURA.ne.jp

From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical"

This reverts commit 0f6d24f878568fa ("mm/page-writeback.c: print a warning
if the vm dirtiness settings are illogical") because it causes false
positive warnings during OOM situations as noticed by Tetsuo Handa:

[  621.814512] Node 0 active_anon:3525940kB inactive_anon:8372kB active_file:216kB inactive_file:1872kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:2504kB dirty:52kB writeback:0kB shmem:8660kB s
hmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 636928kB writeback_tmp:0kB unstable:0kB all_unreclaimable? yes
[  621.821534] Node 0 DMA free:14848kB min:284kB low:352kB high:420kB active_anon:992kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15988kB managed:15904kB mlocke
d:0kB kernel_stack:0kB pagetables:24kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  621.829035] lowmem_reserve[]: 0 2687 3645 3645
[  621.831655] Node 0 DMA32 free:53004kB min:49608kB low:62008kB high:74408kB active_anon:2712648kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:3129216kB managed:
2773132kB mlocked:0kB kernel_stack:96kB pagetables:5096kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  621.839945] lowmem_reserve[]: 0 0 958 958
[  621.842811] Node 0 Normal free:17140kB min:17684kB low:22104kB high:26524kB active_anon:812300kB inactive_anon:8372kB active_file:1228kB inactive_file:1868kB unevictable:0kB writepending:52kB present:1048576k
B managed:981224kB mlocked:0kB kernel_stack:3520kB pagetables:8552kB bounce:0kB free_pcp:120kB local_pcp:120kB free_cma:0kB
[  621.852473] lowmem_reserve[]: 0 0 0 0
[...]
[  621.891477] Out of memory: Kill process 8459 (a.out) score 999 or sacrifice child
[  621.894363] Killed process 8459 (a.out) total-vm:4180kB, anon-rss:88kB, file-rss:0kB, shmem-rss:0kB
[  621.897172] oom_reaper: reaped process 8459 (a.out), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  622.424664] vm direct limit must be set greater than background limit.

The problem is that both thresh and bg_thresh will be 0 if
available_memory is less than 4 pages when evaluating
global_dirtyable_memory.  While this might be worked around the whole
point of the warning is dubious at best.  We do rely on admins to do
sensible things when changing tunable knobs.  Dirty memory writeback knobs
are not any special in that regards so revert the warning rather than
adding more hacks to work this around.

Debugged by Yafang Shao.

Link: http://lkml.kernel.org/r/20171127091939.tahb77nznytcxw55@dhcp22.suse.cz
Fixes: 0f6d24f87856 ("mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    7 -------
 mm/page-writeback.c         |    5 +----
 2 files changed, 1 insertion(+), 11 deletions(-)

diff -puN Documentation/sysctl/vm.txt~revert-mm-page-writebackc-print-a-warning-if-the-vm-dirtiness-settings-are-illogical-was-re-mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~revert-mm-page-writebackc-print-a-warning-if-the-vm-dirtiness-settings-are-illogical-was-re-mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical
+++ a/Documentation/sysctl/vm.txt
@@ -158,10 +158,6 @@ Note: the minimum value allowed for dirt
 value lower than this limit will be ignored and the old configuration will be
 retained.
 
-Note: the value of dirty_bytes also must be set greater than
-dirty_background_bytes or the amount of memory corresponding to
-dirty_background_ratio.
-
 ==============================================================
 
 dirty_expire_centisecs
@@ -181,9 +177,6 @@ generating disk writes will itself start
 
 The total available memory is not equal to total system memory.
 
-Note: dirty_ratio must be set greater than dirty_background_ratio or
-ratio corresponding to dirty_background_bytes.
-
 ==============================================================
 
 dirty_writeback_centisecs
diff -puN mm/page-writeback.c~revert-mm-page-writebackc-print-a-warning-if-the-vm-dirtiness-settings-are-illogical-was-re-mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical mm/page-writeback.c
--- a/mm/page-writeback.c~revert-mm-page-writebackc-print-a-warning-if-the-vm-dirtiness-settings-are-illogical-was-re-mm-print-a-warning-once-the-vm-dirtiness-settings-is-illogical
+++ a/mm/page-writeback.c
@@ -433,11 +433,8 @@ static void domain_dirty_limits(struct d
 	else
 		bg_thresh = (bg_ratio * available_memory) / PAGE_SIZE;
 
-	if (unlikely(bg_thresh >= thresh)) {
-		pr_warn("vm direct limit must be set greater than background limit.\n");
+	if (bg_thresh >= thresh)
 		bg_thresh = thresh / 2;
-	}
