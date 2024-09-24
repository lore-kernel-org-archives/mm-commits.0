Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC83A186E2A
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 23:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727220268; cv=none; b=jGVPAfL9J8STEGBRXNfPpBOIrkkmgkMXGBiuWnNpz+GgQ3OEdcpazbpCgYIKXENgZtyxAEC6XfLh3e5lrApfZFI/Es0WqsTr64Qlq6yxNgA5cDhiow9nAeAKXaHu84QZ87Sll9U3Oe0sRr+vbPKmiXxmw8EvIqng+/ndkPb6jkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727220268; c=relaxed/simple;
	bh=pzCKjPfx3Z3sr6NSP09VagLERNX8SU7f/p1MeR4SKyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB0wguSloG++jXcuR7s6vg0QWd2CiL7pjWaKK8QuIJmagr/SHx26hS4Df+p0Uospj+Om7+v4KNkclp+85R9GE+MjsRXYvlY6fTmy8x8zjAxCW4Ttc0pNFp+sQ31kR0bYgsGSdR5YZiIJANFlrwHEZBz6guwl1b2e4LqQehAhN4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebRmRAVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebRmRAVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A004C4CEC4;
	Tue, 24 Sep 2024 23:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727220268;
	bh=pzCKjPfx3Z3sr6NSP09VagLERNX8SU7f/p1MeR4SKyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebRmRAVJ0n/p/EzWQ9a3WJsoaiqx1MeP/9hZAW6k3/2IuOWBkdQRG1QuZiCXd79hv
	 PQbHA5oBwu7JtMLORyMo7jE5j9UHY8fzgQszKGULY4aQ7CrD/hBr1TPPq+uYSajzic
	 PMKS0sj8+fZnGuzzLcJK1abCjJlK1cU774OLITKY0O60UbHam10AC5tnkReLAds+jB
	 //fO9GhDYKfUnCH6Py7IoAdH7+xmYLPopiwXobDmsvulpAso5Au8NoN3yYjIssYaRI
	 htAHBgD1WWCyFyuaso//0rme3N6sd3Vu/eeG3ETJ6hARL3BAfRDFNrMz/QxUavl6Ie
	 mLSBTRypD5cpg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	skhan@linuxfoundation.org,
	ruanjinjie@huawei.com,
	leocstone@gmail.com
Subject: Re: + mm-damon-fix-sparse-warning-for-zero-initializer.patch added to mm-unstable branch
Date: Tue, 24 Sep 2024 16:24:24 -0700
Message-ID: <20240924232425.752365-1-sj@kernel.org>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240924231757.E7EA5C4CEC4@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 24 Sep 2024 16:17:57 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

[...]
 From: Leo Stone <leocstone@gmail.com>
> Subject: mm/damon: fix sparse warning for zero initializer
> Date: Sun, 22 Sep 2024 19:25:18 -0700
> 
> sparse warns about zero initializing an array with {0,}, change it to
> the equivalent {0}.
> 
> Fixes the sparse warning:
> mm/damon/tests/vaddr-kunit.h:69:47: warning: missing braces around initializer
> 
> Link: https://lkml.kernel.org/r/xriwklcwjpwcz7eiavo6f7envdar4jychhsk6sfkj5klaznb6b@j6vrvr2sxjht
> Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
> Signed-off-by: Leo Stone <leocstone@gmail.com>
> Cc: Jinjie Ruan <ruanjinjie@huawei.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Actually I also gave [1] my Reviewed-by: tag, but seems it got dropped from v2
of this patch.  So, trying again.

Reviewed-by: SeongJae Park <sj@kernel.org>

[1] https://lore.kernel.org/20240922151121.469051-1-sj@kernel.org


Thanks,
SJ

[...]
