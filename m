Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8C580025
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UjiLIm42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB4AC433C9;
	Tue, 12 Dec 2023 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407559;
	bh=LFxiC7A01EVqET/twLQz6ZRpQhKUCgU+ejsMp0y9fgE=;
	h=Date:To:From:Subject:From;
	b=UjiLIm42cPTjIQ8elu7ynrdkb6eLaA9HFh7iAsdFvFmSUBvpAhMSCDTZDq/suYliL
	 xf76jUNYW0I48gmXL9u0yobChcoGl+k432W+XgHmnMzWavEZbi22E8A3fYXBW38ieh
	 eRYPR5Qkvx24dtZ/gziS+XIPewezJ7ABTdVPKWZQ=
Date: Tue, 12 Dec 2023 10:59:18 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,shuah@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,cerasuolodomenico@gmail.com,bagasdotme@gmail.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-implement-mem_cgroup_tryget_online.patch removed from -mm tree
Message-Id: <20231212185919.3AB4AC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol: implement mem_cgroup_tryget_online()
has been removed from the -mm tree.  Its filename was
     memcontrol-implement-mem_cgroup_tryget_online.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: memcontrol: implement mem_cgroup_tryget_online()
Date: Thu, 30 Nov 2023 11:40:19 -0800

This patch implements a helper function that try to get a reference to an
memcg's css, as well as checking if it is online.  This new function is
almost exactly the same as the existing mem_cgroup_tryget(), except for
the onlineness check.  In the !CONFIG_MEMCG case, it always returns true,
analogous to mem_cgroup_tryget().  This is useful for e.g to the new zswap
writeback scheme, where we need to select the next online memcg as a
candidate for the global limit reclaim.

Link: https://lkml.kernel.org/r/20231130194023.4102148-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/memcontrol.h~memcontrol-implement-mem_cgroup_tryget_online
+++ a/include/linux/memcontrol.h
@@ -821,6 +821,11 @@ static inline bool mem_cgroup_tryget(str
 	return !memcg || css_tryget(&memcg->css);
 }
 
+static inline bool mem_cgroup_tryget_online(struct mem_cgroup *memcg)
+{
+	return !memcg || css_tryget_online(&memcg->css);
+}
+
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 	if (memcg)
@@ -1348,6 +1353,11 @@ static inline bool mem_cgroup_tryget(str
 {
 	return true;
 }
+
+static inline bool mem_cgroup_tryget_online(struct mem_cgroup *memcg)
+{
+	return true;
+}
 
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-memcontrol-implement-zswap-writeback-disabling.patch

