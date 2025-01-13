Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248D170A0B
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742270; cv=none; b=kdOwzH0OBI/C3eMgKgwJtNW3xjafojjgq5eBvlPd1ndezrGOazawx66XgYPaAeVGd/XyVbJHdOVC75Vn04VsflTSt+kKaM4Xd5tLmtH7PJBtRq2OCCbvuIkWoJI3b5zX82Vw1GRR/tVita6jmHuhMy9+1BPyG9gyWONxMD/BY7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742270; c=relaxed/simple;
	bh=aBrwkwS+P285M0MKxaZaB/nG18SdWrj80wn6qg0PzGY=;
	h=Date:To:From:Subject:Message-Id; b=LtklvoOALngaiikxUwR1mmzIxiC//xrZUw8XdWlLTZZW/nL04YSm1M74E87aMUBDw2i9n0y2Fh2Yl3VvzaxoMDu6R3cRoeqYzQiOmSKvwYvCzbgXs8AOKGyDDuSIE8RDKA/WeyPBdG/LGtL6JJpN2Cqd72sNO9GtsFprdoo8WY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y5aiOqKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y5aiOqKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F6FC4CED6;
	Mon, 13 Jan 2025 04:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742270;
	bh=aBrwkwS+P285M0MKxaZaB/nG18SdWrj80wn6qg0PzGY=;
	h=Date:To:From:Subject:From;
	b=Y5aiOqKsGi0aRyIiN7VKnPAqeIRSX4faS5GS8Z4sKI3WaTXW7gowzQ9rPj9sXUf/S
	 Nm2NBq0O4vvsx/EpUi27wrPaZpWu+hooA7yUbqBd6bok/YyjbOzrbl0d9+kIcLzLhy
	 l6GTcXyMbhLjJKM3DjXNeBTabMgG5K6oNwXyUEK8=
Date: Sun, 12 Jan 2025 20:24:29 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,paulmck@kernel.org,lukas.bulwahn@gmail.com,kjlx@templeofstupid.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,me@davidreaver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-remove-migrated-rcu-apis-from-deprecated_apis.patch removed from -mm tree
Message-Id: <20250113042429.D5F6FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: remove migrated RCU APIs from deprecated_apis
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-migrated-rcu-apis-from-deprecated_apis.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Reaver <me@davidreaver.com>
Subject: checkpatch: remove migrated RCU APIs from deprecated_apis
Date: Wed, 8 Jan 2025 11:24:54 -0800

The deprecated_apis map was created in [1] so checkpatch would flag
deprecated RCU APIs.  These deprecated APIs have since been removed from
the kernel.  This patch removes them from this map so checkpatch doesn't
waste time looking for them, and so readers of checkpatch looking for
deprecated APIs don't waste time searching for them.

Link: https://lore.kernel.org/all/20181111192904.3199-13-paulmck@linux.ibm.com/ [1]

Link: https://lkml.kernel.org/r/20250108192456.47871-1-me@davidreaver.com
Signed-off-by: David Reaver <me@davidreaver.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Krister Johansen <kjlx@templeofstupid.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ----------
 1 file changed, 10 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-remove-migrated-rcu-apis-from-deprecated_apis
+++ a/scripts/checkpatch.pl
@@ -834,16 +834,6 @@ foreach my $entry (@mode_permission_func
 $mode_perms_search = "(?:${mode_perms_search})";
 
 our %deprecated_apis = (
-	"synchronize_rcu_bh"			=> "synchronize_rcu",
-	"synchronize_rcu_bh_expedited"		=> "synchronize_rcu_expedited",
-	"call_rcu_bh"				=> "call_rcu",
-	"rcu_barrier_bh"			=> "rcu_barrier",
-	"synchronize_sched"			=> "synchronize_rcu",
-	"synchronize_sched_expedited"		=> "synchronize_rcu_expedited",
-	"call_rcu_sched"			=> "call_rcu",
-	"rcu_barrier_sched"			=> "rcu_barrier",
-	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
-	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
 	"kmap"					=> "kmap_local_page",
 	"kunmap"				=> "kunmap_local",
 	"kmap_atomic"				=> "kmap_local_page",
_

Patches currently in -mm which might be from me@davidreaver.com are


