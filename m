Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5929323D291
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161610; cv=none; b=fSmMGNEDJGUQQiNq7JDsOA6fwCJkbZN+jiTHTyPUS85Yv114VqrvntLLL8oyNq2FRk4RC7Imkh7sizY+AAmm+6s8QzjDSBeh/SF7MqVxh2LxfP9eiStla3G4M8SW+w5jL910OmjzBiKok8XL0iOYYqWl72cy277fsvzK4LyGcKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161610; c=relaxed/simple;
	bh=F+Zqjb6nApUY4jOxCWdcU+GO0jUgVW1140gXytan8Hg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kL2UN4Sgp54ZZPqi51FjrVUqqDqcb7YDroGs+aPyOQF/n2s5qGmb5PLBZd78wGp7EoHl7xRMVK6U4HRZSbuOuDprKGydxni6k037HB51fDnEn6sc5LU9vGNNKjexKDGRMeI5qn8YbW13ZwXYuQiIgcAc54SaohuormFMwZfR9LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wQDy4ydo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wQDy4ydo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01491C4CEEF;
	Sat,  2 Aug 2025 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161610;
	bh=F+Zqjb6nApUY4jOxCWdcU+GO0jUgVW1140gXytan8Hg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wQDy4ydo9UfB6OlrMVvmOouImFqzmfhOiL+M+YuWyzCr2oBEd5o60v5FRNhC93SUs
	 zGc8vy+RLEm7uXE++MIq16Ak/s2HwjnNNg09dWWa6FKe0/mltlZDNiqhNoGlpuygjJ
	 Ue4g8jxXSzEphLj2BZIIrhU7jd0BZe0GamBkoDrc=
Date: Sat, 2 Aug 2025 12:06:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: mm-commits@vger.kernel.org, ville.syrjala@linux.intel.com,
 patryk@kowalczyk.ws, baolin.wang@linux.alibaba.com
Subject: Re: [merged mm-stable]
 mm-shmem-fix-the-shmem-large-folio-allocation-for-the-i915-driver.patch
 removed from -mm tree
Message-Id: <20250802120649.4b33511bfb2dba4ee0bfbc71@linux-foundation.org>
In-Reply-To: <1afd8dae-1665-ce19-9464-d993c8e1e6b2@google.com>
References: <20250802185352.DAA62C4CEEF@smtp.kernel.org>
	<1afd8dae-1665-ce19-9464-d993c8e1e6b2@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 2 Aug 2025 11:58:58 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> > Link: https://lkml.kernel.org/r/f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com
> > Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> > Reported-by: Ville Syrj??l?? <ville.syrjala@linux.intel.com>
> > Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> > Suggested-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Thank you Andrew: but please add in the
> Cc: <stable@vger.kernel.org>
> which you corrrectly gave the v1 patch it replaces.

Done, thanks.
