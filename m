Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7562E3F2
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708291338; cv=none; b=JleLqbSwNL+P6ueAd2e2LqmNUV/RM/2f5A1UE4P8UN9IOCllBnT0U32mq3gl1iDfcL36eYbN3DncoMW7A971PdxtR7sbsg3FHfL0l7k/Fl5el70EMYo4Osz/uA43gayz9vmS9knqSofEPDWBZYH8BEpmb7BVDeAG/2TSUCLdmCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708291338; c=relaxed/simple;
	bh=PxkDHn+NauHmUm34KZrf/JMYIECpQJO07LTgBNCT270=;
	h=Date:To:From:Subject:Message-Id; b=ITQQkPiD/MQ+xPSphAPw2uxctGtxdVknlMz4EN/B4lKecgi76qblZWMHlxMa8bI9g2MODi+TAdal17GlQcMnN0X73Xpk0cn/LdQYrm+vsxlDsK09HKsFl1/ZJ4ansIXuK9O/opzkaROfrb7Afmx3WjGdAqdNfFIcFGjRL8W4cds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P0bWSuyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P0bWSuyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1F1C433C7;
	Sun, 18 Feb 2024 21:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708291338;
	bh=PxkDHn+NauHmUm34KZrf/JMYIECpQJO07LTgBNCT270=;
	h=Date:To:From:Subject:From;
	b=P0bWSuyT8Sba05cH0RKv9oC8GJSSSX8gggG55QHfpic6+4OtHFWPFH+rG/Gd4DQwC
	 MLfiyRmbgFx0aR2dVFakvHFcpE4fNkXwzV7U6QXPFykN3KrZHk03Zt+/SSbqcBhIRT
	 BfLve1dB22xmQ292oAXA7wCGLGNHYm+i7BGGJpLs=
Date: Sun, 18 Feb 2024 13:22:17 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,mcgrof@kernel.org,echanude@redhat.com,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + modules-wait-do_free_init-correctly-v3.patch added to mm-unstable branch
Message-Id: <20240218212217.EA1F1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: modules: wait do_free_init correctly
has been added to the -mm mm-unstable branch.  Its filename is
     modules-wait-do_free_init-correctly-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/modules-wait-do_free_init-correctly-v3.patch

This patch will later appear in the mm-unstable branch at
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
From: Changbin Du <changbin.du@huawei.com>
Subject: modules: wait do_free_init correctly
Date: Sat, 17 Feb 2024 16:18:10 +0800

amend comment in do_init_module() and update commit msg

Link: https://lkml.kernel.org/r/20240217081810.4155871-1-changbin.du@huawei.com
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Tested-by: Eric Chanudet <echanude@redhat.com>
Cc: Xiaoyi Su <suxiaoyi@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/module/main.c~modules-wait-do_free_init-correctly-v3
+++ a/kernel/module/main.c
@@ -2598,8 +2598,8 @@ static noinline int do_init_module(struc
 	 * Note that module_alloc() on most architectures creates W+X page
 	 * mappings which won't be cleaned up until do_free_init() runs.  Any
 	 * code such as mark_rodata_ro() which depends on those mappings to
-	 * be cleaned up needs to sync with the queued work - ie
-	 * rcu_barrier()
+	 * be cleaned up needs to sync with the queued work by invoking
+	 * flush_module_init_free_work().
 	 */
 	if (llist_add(&freeinit->node, &init_free_list))
 		schedule_work(&init_free_wq);
_

Patches currently in -mm which might be from changbin.du@huawei.com are

modules-wait-do_free_init-correctly.patch
modules-wait-do_free_init-correctly-v3.patch

