Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14342594B4
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736469231; cv=none; b=o8dVbGDrMzpIGcvcTPwFQnm36ySjlW4BvYPIaHrKKG654n4dsZdR7akg07/9c+qQCZCHcgGE22rk8yP2+i73rYZe2L9nnsZYv2JTxjoOfnbXfZlwgVZZ3PUkFAsL8ZxQ5csT4FJfbd6CBvuyLKjUlMmdCQIu7NgIlvEF1MB+g3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736469231; c=relaxed/simple;
	bh=ys15W4sQugxw+ySGfONk86N5D82418hdoAduWiSNfME=;
	h=Date:To:From:Subject:Message-Id; b=sPUWAoFwqEFJX/d/MjlQpYZMzyJtm7Hw+EecN8YTUSayl8hooEzLAe8kL+I4n58Mlt6F/R/Td4dM2Tlf/OL4qHQSZHN76HuTxm/5rYImJl7WR6g+eUsQrM2hNg/b+gIggyUzNYzuAiNHooxsCG3uooDMiHIcor5mU26XsEKjPes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LgQzQ1B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LgQzQ1B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F76C4CED2;
	Fri, 10 Jan 2025 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736469231;
	bh=ys15W4sQugxw+ySGfONk86N5D82418hdoAduWiSNfME=;
	h=Date:To:From:Subject:From;
	b=LgQzQ1B5JE6DhYafOUCAUoLwrvMfNUkNH/YEf0U6uwHmenDndfSkK6fvjxxitk2/1
	 SJmM8vZzot6ul9NOesWWQ+JHkS2vLjFf1BWD+hnRgm7TfQDf5HyhR9c5ZWT6a5t3RU
	 d9HduqYarycz0ajOhZZ6xspW+//RNtgp5YNOJzdI=
Date: Thu, 09 Jan 2025 16:33:50 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,paulmck@kernel.org,lukas.bulwahn@gmail.com,kjlx@templeofstupid.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,me@davidreaver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-remove-migrated-rcu-apis-from-deprecated_apis.patch added to mm-nonmm-unstable branch
Message-Id: <20250110003350.E7F76C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: remove migrated RCU APIs from deprecated_apis
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-remove-migrated-rcu-apis-from-deprecated_apis.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-remove-migrated-rcu-apis-from-deprecated_apis.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

checkpatch-remove-migrated-rcu-apis-from-deprecated_apis.patch

