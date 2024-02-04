Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B78E8820;
	Sun,  4 Feb 2024 07:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031239; cv=none; b=HqXb96YDuKyghyxcwEgPJ4tnCO7Ws/A9A8ru3l4jmPQIIdSQN7ertZjx30wnEEjn54+UEvNk/ERHScLeGy5bDlNhqAad2MfYutpAsaK1NouQEHJKtwb3S7mUB6iWvY+n0IIs30e0uCwVwxLFgukff3KUqhAj1fvUeI9lz++L6I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031239; c=relaxed/simple;
	bh=kLLc1Pp1sPfvj32S1grdwJML3XhyPkARWwtiI7ATrAQ=;
	h=Date:To:From:Subject:Message-Id; b=oth1o+nyibL5k2OeThKFrzrlYjh9ajFFzhCVRKOqVAJSoEXz0cKSU4b5jJfazRxfJOAHbhuvYC4aev1X1zHjJMe5LdT54Iu44NgfUr93+48uB1fIxkG/qPg2s40sduEfLiBfKB0KNqoeguspP442RmV6GEfQUUb3CqHrq4Caz6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2VV4NUsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2VV4NUsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544BFC433F1;
	Sun,  4 Feb 2024 07:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031239;
	bh=kLLc1Pp1sPfvj32S1grdwJML3XhyPkARWwtiI7ATrAQ=;
	h=Date:To:From:Subject:From;
	b=2VV4NUsLMA7bOugLVH+VTC0f1ZIGVu/2vRmCBR8yDQCQMn7JV7WI7hoVtnRnsEqLP
	 5ZymJrIF0Iq2UMIJ26WbjlY8bKDFZUF/9R3H8ZvIJM5pUt6tJfxXDHNjqcr7+iEuQl
	 B2pUGfYCHr2uloGs7ZhVSaJDebRdz+UDz1BcCCOQ=
Date: Sat, 03 Feb 2024 23:20:38 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch added to mm-hotfixes-unstable branch
Message-Id: <20240204072039.544BFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: fix wrong DAMOS tried regions update timeout setup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: fix wrong DAMOS tried regions update timeout setup
Date: Fri, 2 Feb 2024 11:19:56 -0800

DAMON sysfs interface's update_schemes_tried_regions command has a timeout
of two apply intervals of the DAMOS scheme.  Having zero value DAMOS
scheme apply interval means it will use the aggregation interval as the
value.  However, the timeout setup logic is mistakenly using the sampling
interval insted of the aggregartion interval for the case.  This could
cause earlier-than-expected timeout of the command.  Fix it.

Link: https://lkml.kernel.org/r/20240202191956.88791-1-sj@kernel.org
Fixes: 7d6fa31a2fd7 ("mm/damon/sysfs-schemes: add timeout for update_schemes_tried_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup
+++ a/mm/damon/sysfs-schemes.c
@@ -2194,7 +2194,7 @@ static void damos_tried_regions_init_upd
 		sysfs_regions->upd_timeout_jiffies = jiffies +
 			2 * usecs_to_jiffies(scheme->apply_interval_us ?
 					scheme->apply_interval_us :
-					ctx->attrs.sample_interval);
+					ctx->attrs.aggr_interval);
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch

