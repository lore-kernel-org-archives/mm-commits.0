From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch removed from -mm tree
Date: Fri, 24 Jan 2014 10:59:33 -0800
Message-ID: <52e2b815.XSy+e/56JYgnZJNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com

Subject: [merged] mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch removed from -mm tree
To: hughd@google.com,hannes@cmpxchg.org,mhocko@suse.cz,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:33 -0800


The patch titled
     Subject: mm/memcg: iteration skip memcgs not yet fully initialized
has been removed from the -mm tree.  Its filename was
     mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/memcg: iteration skip memcgs not yet fully initialized

It is surprising that the mem_cgroup iterator can return memcgs which have
not yet been fully initialized.  By accident (or trial and error?) this
appears not to present an actual problem; but it may be better to prevent
such surprises, by skipping memcgs not yet online.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized
+++ a/mm/memcontrol.c
@@ -1119,10 +1119,8 @@ skip_node:
 	 * protected by css_get and the tree walk is rcu safe.
 	 */
 	if (next_css) {
-		struct mem_cgroup *mem = mem_cgroup_from_css(next_css);
