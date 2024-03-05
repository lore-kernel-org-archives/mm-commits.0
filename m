Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53BA8C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600531; cv=none; b=qi3DM7uw6i4Ny/BliTTGimgt5no2BL+DEZGqPGZpFphbpVG5yBeuEh1ZBHAyM8DdZ0fww2wYiHP399N/I7kA4DLVjtPLi1OLphZNNLKFdZ2D+F+RY+JsImB6gljPU/a1miQadQ8Hlx+eWuAqeU6ld2nQpoLLV1TmOdWT+hal2pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600531; c=relaxed/simple;
	bh=wN30d+aQVy5OZbzybs6XewTYM5DDIuWsswBT8YUvowg=;
	h=Date:To:From:Subject:Message-Id; b=qHCrKPZOm2dFrSMhRZ0c7dBfnL97YAkSD+Rq85fyAYIYdEeJk9ALCzwogy30qeHuP1ghGQEFXpRYy/5ch+qSQxauMi53HM1Q0hwhQ014OYypTNUTz/iZuStQlqZRR35094FAL6lyXnj+NGD5YQlSbA1BU/RG234+RRqQa+4Uisg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/6D1vZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/6D1vZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77159C43394;
	Tue,  5 Mar 2024 01:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600531;
	bh=wN30d+aQVy5OZbzybs6XewTYM5DDIuWsswBT8YUvowg=;
	h=Date:To:From:Subject:From;
	b=a/6D1vZvDTfgrqzYm+H4cIshFIzSXXipJtUmMz00hF128Bs92LHmxi8cEjRrspGH+
	 qwPXVDhU07XavXRabNFHLmytb4vbaCibjjLZX3gMhGXjkWkWHIP0zvxD6Vv+rKOP2q
	 vrFeXQp5GEt0+Z7VEJz7zuNRxjboVNlz5iZgY6ow=
Date: Mon, 04 Mar 2024 17:02:11 -0800
To: mm-commits@vger.kernel.org,vincenzo.mezzela@gmail.com,sj@kernel.org,bernd.edlinger@hotmail.de,javier.carrasco.cruz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-access_memory-to-gitignore.patch removed from -mm tree
Message-Id: <20240305010211.77159C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: damon: add access_memory to .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-access_memory-to-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Subject: selftests: damon: add access_memory to .gitignore
Date: Wed, 21 Feb 2024 13:11:48 -0800

This binary is missing in the .gitignore and stays as an untracked file.

Link: https://lore.kernel.org/r/20240214-damon_selftest_gitignore-v1-1-f517d0f9f783@gmail.com
Link: https://lkml.kernel.org/r/20240221211148.46522-3-sj@kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Singed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Closes: https://lore.kernel.org/all/AS8P193MB1285C963658008F1B2702AF7E4792@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM/
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-add-access_memory-to-gitignore
+++ a/tools/testing/selftests/damon/.gitignore
@@ -2,3 +2,4 @@
 huge_count_read_write
 debugfs_target_ids_read_before_terminate_race
 debugfs_target_ids_pid_leak
+access_memory
_

Patches currently in -mm which might be from javier.carrasco.cruz@gmail.com are


