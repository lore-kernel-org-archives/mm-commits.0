Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897CF482F7
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175124; cv=none; b=bmyzpAXWd5WV1shvagEQLkyuinHjuMmmuNQEeZNXyk2BahX2GKV/dmcQ4gszpn9sCbQrcolqofetXVmh6gtJ91rQgAVDTzcqtAZxeqs4XCIKpfhjmiJlKE4Oiyolpn/cUC8v0vrO01R5GTK874CpQ4OU8kyPj+iqqe9b+F6AgjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175124; c=relaxed/simple;
	bh=3ygsNMDpyUq6VTdW3UTMZRGUIYAxxOApydtfQ7uc6xQ=;
	h=Date:From:To:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=BTLNlZEWE2vTKcsVvDE1ftariuch/qE6qruoOesNbEqTNuoCcDx0EpBrh1ZjU4grr7wp3e4QwYeBspGcxFIQjsS2FMF3kkz82QrW7uDfmzcnSX6yr7HANMwfxaJSuQ0WqRk7R9Crm5GoNjpLy4W35e2jLalbEv31vNp4TOM7z0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtrcQRf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtrcQRf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A092C433C7;
	Mon,  5 Feb 2024 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707175124;
	bh=3ygsNMDpyUq6VTdW3UTMZRGUIYAxxOApydtfQ7uc6xQ=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=AtrcQRf0ns9ua5P1SRhEDbynjsQzh+a7+yrtsZoBpIx/gnZePIPsiW2ZgTNsF7R1A
	 /0Cu8rCgTq6QKthgfcXqNi9giV89ttbjcJfagBj7JzuoxaM7Y9uRMmOVevtJOptLtj
	 90o76ZqoP4surF6/EmEMQi9XpFqeleYGyzFONRVbODPknVspOb8m50Yj8vbqXqIH89
	 4fs9ekrVKNMpvp2Wdhl9jASLoDWWIqMgH33lJu/aLOSiWQFNSN/3CIbP9v0mJDgPCd
	 aDlmdXl10uPdDDGk6Q0iaKLp19ocrpth/wN7Y0kPnJC+guTX+9qXtxFEWl49WSGtzM
	 DGyGADzV/cimA==
Date: Mon, 05 Feb 2024 23:18:42 +0000
From: Kees Cook <kees@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 ryabinin.a.a@gmail.com, przemyslaw.kitszel@intel.com, peterz@infradead.org,
 ojeda@kernel.org, nicolas@fjasle.eu, ndesaulniers@google.com,
 nathan@kernel.org, masahiroy@kernel.org, justinstitt@google.com,
 haoluo@google.com, elver@google.com, andreyknvl@gmail.com,
 keescook@chromium.org, akpm@linux-foundation.org
Subject: =?US-ASCII?Q?Re=3A_+_ubsan-reintroduce-signed-overflow-s?= =?US-ASCII?Q?anitizer=2Epatch_added_to_mm-unstable_branch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20240205230850.07CA4C433C7@smtp.kernel.org>
References: <20240205230850.07CA4C433C7@smtp.kernel.org>
Message-ID: <FF9AF667-26A2-4006-A81E-A1C32DCBC8FF@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On February 5, 2024 11:08:49 PM GMT, Andrew Morton <akpm@linux-foundation=
=2Eorg> wrote:
>
>The patch titled
>     Subject: ubsan: reintroduce signed overflow sanitizer
>has been added to the -mm mm-unstable branch=2E  Its filename is
>     ubsan-reintroduce-signed-overflow-sanitizer=2Epatch

You can drop this, I'll carry it in my tree=2E

Thanks!


--=20
Kees Cook
