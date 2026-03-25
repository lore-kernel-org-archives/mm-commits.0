Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684F83FB7D4
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774458239; cv=none; b=OR927JDldp6N8IXmAwdVf+7wWxuuFLXSPOAulQ/C5J+E9La4+XUjdKgDOi9shM51+amEiFnuv3yXznAi4778J93XyzZ2f5SIJ3Ye+wAAJSDjTXChlBbFP7C19U6jGN2zIgIMqkDhjFCvYH6k1jRVxf3Z42s11CgV0HobfsdV+94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774458239; c=relaxed/simple;
	bh=yPRKtjNddL58gPBDymcDoq0V1wD27v5i4sn6/mbKj7o=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d/WSGre5vtlCTkvfcs8Z6ooxj1V3tBgVjeJ5Q/m2ohdUinrnnRl6Qk+JZf7t12QYSn71VmwEi/4egwVKwXAE4NlBLY5uqEIlvwMDxk2ijnjZlgn0BbxQDRx0ctUQ2d4IPRW8RJYiS+/FVnw+qmNxLEpENExfuYtdGCGMSep6Ajc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/Wm7eFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/Wm7eFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBEAC4CEF7;
	Wed, 25 Mar 2026 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774458238;
	bh=yPRKtjNddL58gPBDymcDoq0V1wD27v5i4sn6/mbKj7o=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=Q/Wm7eFRX9Kokh0w28oFPIpkvpjGvq/7x9T/Z5zanjam/ZUNUYyZA0BZUsGSqBwHr
	 GbwAB3B38+ScCIc3Lpo2I0V0jFy1U6jUI6ff3qc38bbsJn+6vw0bMFBgbjOYqg2LL0
	 2/ZSugERNI5CBoqcAg7VUaJN1nyiW7KsUoB+WAHXIpXCnOPFCpjHNw+zUamELzQRZN
	 nubcSsaiXBdln0mbUls0hihZxn20gg+cSnugr2iNt4dBIeGvm1NVzr9Xrf1mkznUTH
	 9VCekg89PB8BvRiQeNOuFOliDaUdRZG2gGeGqZOlP09mPJMy+LDzHmPQheX8ToLTyr
	 ucUJCYew2bjKQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 bblock@linux.ibm.com, akpm@linux-foundation.org
Subject: Re: +
 debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
 added to mm-nonmm-unstable branch
In-Reply-To: <20260311174822.42D6DC4CEF7@smtp.kernel.org>
References: <20260311174822.42D6DC4CEF7@smtp.kernel.org>
Date: Wed, 25 Mar 2026 18:03:55 +0100
Message-ID: <87qzp7et8k.ffs@tglx>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Andrew!

On Wed, Mar 11 2026 at 10:48, Andrew Morton wrote:
> The patch titled
>      Subject: debugobjects: allow to configure the amount of pre-allocated objects
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch

Can you please drop this. The underlying problem is not explained at
all and the question I asked vs. deferred page init is not answered.

Thanks

        tglx
