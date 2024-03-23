Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B101A31
	for <mm-commits@vger.kernel.org>; Sat, 23 Mar 2024 00:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711154184; cv=none; b=tV7RNjRnA4RtqcvlYAxLlPqcXNAdN5QPAekN+WBEkAwXMaiGbDt05o8NUC4+GvFgKwEpYT7ZsAnDH145eZ2yFKiu9Msmua73gY0+UVja23Fp5IfFTWEjllA2eHP21HV0bq3G2hGXtp45jZJHo9uGdb89obdmPYYWIFsBIDHfv0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711154184; c=relaxed/simple;
	bh=iVuD7Yi+dNMseVgnme8uhvVqffwUwqj3bREgGu+rKqU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HMZl+kgivpXsECFYSrIGeL5W0eGHEQknU2+bcGSNQaaBQTElm81bKz8epuUyrjZpA3zu67Enz34nCT3NRGAJLyo0+guIKefSs9srbFmcyNy6TumrwgShcRl0ebQynLs8FQ+Y9+5NwV54mloBHEVsi8LaorOiTIqNcC4hsHxUsnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20891C087C;
	Sat, 23 Mar 2024 00:30:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id D28D22000F;
	Sat, 23 Mar 2024 00:30:07 +0000 (UTC)
Message-ID: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
Subject: Re: +
 scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
 v-songbaohua@oppo.com, sfr@canb.auug.org.au, lukas.bulwahn@gmail.com, 
 linux@roeck-us.net, jcmvbkbc@gmail.com, herbert@gondor.apana.org.au, 
 dwaipayanray1@gmail.com, corbet@lwn.net, chris@zankel.net,
 chenhuacai@loongson.cn,  broonie@kernel.org, apw@canonical.com,
 ma.xxn@outlook.com
Date: Fri, 22 Mar 2024 17:30:06 -0700
In-Reply-To: <20240322190659.E6A0EC433C7@smtp.kernel.org>
References: <20240322190659.E6A0EC433C7@smtp.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 4wqrzd33jatsqbpsa568bucdf5k3k7y7
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: D28D22000F
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18MwJowyO8ZKlY2PUprhqd5Obo8Y5PBcI4=
X-HE-Tag: 1711153807-539634
X-HE-Meta: U2FsdGVkX1+boOfylmH3WIvp4jChUqnaIBrzfmzPEFOYMhCxkMrywLs26h6SfEq8yjg5MU7tF7wnFAVL0zOWv80ilj25yfI264AaEh0gtTOuDpxmYd/NG4D9j3MY8KHfSu//D16OHfS8h/6yFBtk09b73LtcarS+vNDIsezouaNFNgIcQ0pB7mh1DXUjcTujHgxKSV7tEDbpi+bswt0L/P9zWGT92045btHoBgQ+mFug1vGxCTAIWk2CYmhl5aCZYXSsSGhl4KReBr4zWAYgr5k+VoohJ5lcYTfpu6kFfk4DC1a/71JiyFg43j6DJLbe

On Fri, 2024-03-22 at 12:06 -0700, Andrew Morton wrote:
> The patch titled
>      Subject: scripts: checkpatch: check unused parameters for function-l=
ike macro
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      scripts-checkpatch-check-unused-parameters-for-function-like-macro.p=
atch

Conceptually I don't disagree but I wonder what the false
positive rate is.

