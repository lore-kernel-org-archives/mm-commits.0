Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BC6399
	for <mm-commits@vger.kernel.org>; Sun, 24 Mar 2024 00:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711240339; cv=none; b=HpdlYwobuOJbWGWjjRXgflC2vpusBTX7eqOD1kIDzNg4Ch6Wxszgnq3NKby2OHXtWqJkhvxo9aMiWKgwWjKplhirghRN/WL31RwUAc1MV0g60vBson1JpeuJLI5JfzaoH1xNOJKS/QvW2M0FvIv7mS7FdOtTjp7nZAQCoJ1eQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711240339; c=relaxed/simple;
	bh=cgCFk8EfEAJNZ390U/0iQMaD6a493x5+Tmzqq8lqRf8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gqP5fvOzByq8s3rtKz4UQRqAMmDBAA6w/8Godpue+IiH+S/E0GGQIEltqaTZpwXlJf9UkPWKQxMV5qY0opB6xvk6nkKv0s/ktCNsWnOo7qqzPhZv8TT0kovSiqZkUBu/rOfDPfJsV7blKwwImjBOSoibW+JvCWefqmcYciC8S78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07F481206AA;
	Sun, 24 Mar 2024 00:32:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 80E9120025;
	Sun, 24 Mar 2024 00:32:04 +0000 (UTC)
Message-ID: <99bb12a9f030189c1600b56665ff27c32579e469.camel@perches.com>
Subject: Re: +
 scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
From: Joe Perches <joe@perches.com>
To: Barry Song <21cnbao@gmail.com>, mac.xxn@outlook.com
Cc: akpm@linux-foundation.org, apw@canonical.com, broonie@kernel.org, 
 chenhuacai@loongson.cn, chris@zankel.net, corbet@lwn.net,
 dwaipayanray1@gmail.com,  herbert@gondor.apana.org.au, jcmvbkbc@gmail.com,
 linux@roeck-us.net,  lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
 sfr@canb.auug.org.au,  v-songbaohua@oppo.com
Date: Sat, 23 Mar 2024 17:32:03 -0700
In-Reply-To: <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com>
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
	 <20240323041401.6335-1-21cnbao@gmail.com>
	 <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
	 <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 80E9120025
X-Stat-Signature: tzmf3zd8dbhaypzpyqrjo3hkdi7xs1ms
X-Rspamd-Server: rspamout05
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/KE7+lyQ/A/me8Qqz1VetHAjGcGM0HV54=
X-HE-Tag: 1711240324-884518
X-HE-Meta: U2FsdGVkX19bl7Um7QZni4CfgbWVHPE4zJT0aHvpZqPO51OMBR0j7mLMyYThq7QqwMOYklDg0suu/1Q6SeICGYa6xnuoOYOzliTXk34tofv8dQx6KrFa3y+dONzffaw5ZV4FkcQgSKTYJx4Sn3GE/PhDanfYU5STQ+e33L6b/7u3Cu9QoU7Bz4JJkJJGpZwUkbwsj3z2gXH3SRslnWL0fNVnVbY1u0MHck358jHD0raEhwPCLYd8sAGF5OpLvlqBksJfsLgxwacBIXwZANFajXRipvLbOkGvsp5zNH2LcyWZ3KUnCMhHs314gi5loqZ+pXXjK0XMszwNXmYUjTyAhRZ5rDqZ9Kym

On Sun, 2024-03-24 at 11:40 +1300, Barry Song wrote:
> And include/video/trident.h
>=20
> #if TRIDENTFB_DEBUG
> #define debug(f, a...)  printk("%s:" f,  __func__ , ## a);
> #else
> #define debug(f, a...)
> #endif

btw: the debug cases here should likely be something like:

#if TRIDENTFB_DEBUG
#define debug(fmt, ...)							\
	printk(KERN_DEBUG "%s: " fmt,  __func__, ##__VA_ARGS__)
#else
#define debug(fmt, ...)							\
do {									\
	if (0)								\
		printk(KERN_DEBUG "%s: " fmt, __func__, ##__VA_ARGS__);	\
} while (0)
#endif

to preserve format checking in the !TRIDENTFB_DEBUG case

or just use pr_debug and remove TRIDENTFB_DEBUG and rely
on DYNAMIC_DEBUG to do the same thing.



