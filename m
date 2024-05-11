Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4C8A921;
	Sat, 11 May 2024 22:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467332; cv=none; b=rhet0RQYWOxaIREBIHZLiqpyZ7BP1fjOh0hSZO0FvGlO+VGx6z4glDXF7uB28sJB7DzOCtZQ+FjdQjDkHvvZJMYBq6GoSUn7X1buU3A/n8Hg0RhNEdxrw87KXDR4HPyWrAN6hS3MqgH0tGcQJUEasMdGo2h+pXzpCYVpzxFP/sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467332; c=relaxed/simple;
	bh=F/m0IggXEhP0wpyArqqqpuwi3/I3Vw3UaaV6QJ88RCw=;
	h=Date:To:From:Subject:Message-Id; b=iHqK4FN1siamO+cAdobHg74SHPkHCNfVTD/dKc4T0nuJcRNF9wvKOX9h6UsRaON2JjrpGexnuUpioT1Vr/h5AofimzNEbKX9HGKtPJmYO7Msd79nGSrZWKSVIINDdPJKOIE/wiXQK32meujX75sfaqwxaHd/qolikd8A9UV47/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vIz9Bojb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vIz9Bojb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277E6C32781;
	Sat, 11 May 2024 22:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467332;
	bh=F/m0IggXEhP0wpyArqqqpuwi3/I3Vw3UaaV6QJ88RCw=;
	h=Date:To:From:Subject:From;
	b=vIz9BojbUNMorVnuPmWlW9CtQP6TDcpxUOvIPf/N2ZQPd7EMRK0Vwgu69j+bZ0cs3
	 RAX59YppNfFEP+xeqX8C8fzPPRfAH2DYmOy0tOhzNPD8ZKt+mVzHEvUABOxjbCnmy+
	 LhwNs2VBxRTse74wGF/xAhqJpWUQ0f+adTnJpy3Q=
Date: Sat, 11 May 2024 15:42:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch removed from -mm tree
Message-Id: <20240511224212.277E6C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file
Date: Fri, 3 May 2024 11:03:14 -0700

The example usage of DAMOS filter sysfs files, specifically the part of
'matching' file writing for memcg type filter, is wrong.  The intention is
to exclude pages of a memcg that already getting enough care from a given
scheme, but the example is setting the filter to apply the scheme to only
the pages of the memcg.  Fix it.

Link: https://lkml.kernel.org/r/20240503180318.72798-7-sj@kernel.org
Fixes: 9b7f9322a530 ("Docs/admin-guide/mm/damon/usage: document DAMOS filters of sysfs")
Closes: https://lore.kernel.org/r/20240317191358.97578-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.3.x]
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -434,7 +434,7 @@ pages of all memory cgroups except ``/ha
     # # further filter out all cgroups except one at '/having_care_already'
     echo memcg > 1/type
     echo /having_care_already > 1/memcg_path
-    echo N > 1/matching
+    echo Y > 1/matching
 
 Note that ``anon`` and ``memcg`` filters are currently supported only when
 ``paddr`` :ref:`implementation <sysfs_context>` is being used.
_

Patches currently in -mm which might be from sj@kernel.org are


