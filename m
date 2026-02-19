Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906FD2D46C0
	for <mm-commits@vger.kernel.org>; Thu, 19 Feb 2026 07:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771487069; cv=none; b=jiuh7tvxcrdvu2+7U5srecXc/PIWYPA9iiQr3U7wS49PnV9SZNZ+UZw9ASVOHgToWcHyghfxD6y3J2Q43py9Ak9oRFF8cIwIhrPzCyjY11KS4GLD94rtMJ/cLDChcNrcV9pky7XHlleO9j76kNumB9k/6GSo1krU6Sa14sx/Nog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771487069; c=relaxed/simple;
	bh=1Jc+LAWseHEKCzNX96KFpRTRyUnzRe4cAZh0XrDS7ho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nOszRuf73d4picAXnztmnsuzJlD+lVzsKjPKgSnd0sUTJSfX9q/zegnZyJ/eBqcrvUz2op7TZ20pnn9ybkitssOCfSjkqGlvw2R59gfk+B35na/84k0X/KV1UuUZ4l0hbXAwj4/5+kWi90lRgSqf/B/agg4UqOSPvMkBIZ6ow2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgsVSpY6; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgsVSpY6"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c01595082so750134a12.3
        for <mm-commits@vger.kernel.org>; Wed, 18 Feb 2026 23:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1771487066; x=1772091866; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fiNigTXvKFQq/mQsA2lOiDoUz3cg+K90vNti2KDBySo=;
        b=PgsVSpY6cFtKAG/GULTsObTRBKc06MxMOAnBhpEttzH2R05RUvvzCSiYOCa7e7k9i8
         KiUK8vSHGn/A3fLsrgtYoL0sfvv40j/sUAzEzwDgGZky2L/bnW747GG40zZTEXvyni24
         OOyUMfWUMcOPidGCyv639zZeZo1rWhLXg/OAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771487066; x=1772091866;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiNigTXvKFQq/mQsA2lOiDoUz3cg+K90vNti2KDBySo=;
        b=iJHDmlTgiMKK2nIXoOmMYugZfyqH5GJuQCy9QtkeZOzyoPUUuJjNnE+XJkBzUj6yE6
         9HGaNoQT3CoS5G/mu0IhChP2RHsNU6odQ9ElQsJvWwjDri+x8YmKM35OaShIJ20hcPk0
         Tkr6Zr/YVh2cFAiREQlnmasBX8AGVafUGC8tjpsUwvtK5fAf2sZ6DM9afefKYhWwx87k
         Y86kS2rLe7QqUzdmcsQ7pCCjm54M1ENpi00MrRaHzWDWcUqsXzLNJw9yJzAWCTg69/oo
         FSSIEpZAO2yTVyXxrJAQFgwjY/XAd8NHP7E81KpXLPy6orCHnXF0qsgNJuN+haL0hiQN
         9a+g==
X-Forwarded-Encrypted: i=1; AJvYcCU7vtpEh9QkybmOvJWoLYUyGNT+GP0vPAf3TAror6r2kPYLsYT45m0uvcGZ/GZT8xxU7TIdcK/+PX9G@vger.kernel.org
X-Gm-Message-State: AOJu0YwhiueZaFkIswLO4n7aJBxQrl2MGbb8+z5jZXUeuQM7DZinM+bk
	BMgT3mu1cJpbHK0Bsa26VEY+JiLTbshdrwpdYzFUnkag1jgYqD3QEsSbIw/ftTh/M4DKAFEncja
	AmoMEo4qegA==
X-Gm-Gg: AZuq6aIJVZ1gIaZAZC617XhyZ56U0DFAAV6NYrT5F6elUucT23pISa53ShSQxsM93Gu
	3qB9iV7QxGlUcf9iLJutvPgKVGHNGGzhfmCBnEw4nZ1jEIxXF69Uq3NV0tvnRK/hHcQo+QFSwHr
	Xaxlt+Zby3N09H4JEho0UcSSNGmCTBtjuv0Xjm/nnkLiSl7s/w9TKu2JIaDe0awudAFoTNDLZd4
	Mxn+3hinyI2sDQK8XuEY7UkLfYzVQaKkA47fiaG86vurKxrxJpWJMwCZjolTzuX284zH0pT3nFs
	tUJ5c2o63pmqnzX0yOifUYh8Tpyd2hEDQPvWELVW6KoJVknTq8Zy8lgpcL2kX0EAqiQPssvZ7bm
	r4axLSkis+VsutUR/YoVurOCpP5QIiYsDDmmbtKYSNTp9BsLCc29iXIxjWD0jmC+0KJaCwoNylL
	6SEstmwGpwTGtNCO4/ZCsBJk98bulD7pF/yiLcWpPksVOr1xzyw+5ZSlMhbLC7Z8mPedt5j1c=
X-Received: by 2002:a05:6402:51cd:b0:658:cc59:161c with SMTP id 4fb4d7f45d1cf-65bb112f9aamr9941427a12.12.1771487065729;
        Wed, 18 Feb 2026 23:44:25 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bad3e3538sm3733546a12.20.2026.02.18.23.44.25
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 23:44:25 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso689804a12.2
        for <mm-commits@vger.kernel.org>; Wed, 18 Feb 2026 23:44:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXBCFZ6Yw4cFOCKwjBJAA3NckfQfuzVWj9nmNqoNAPIzWXE54Gdau/2ADIq3vJV4XXCBWEckeMBTcYd@vger.kernel.org
X-Received: by 2002:a17:907:3d8c:b0:b8e:92e:d316 with SMTP id
 a640c23a62f3a-b8fb452e7d1mr1091137466b.56.1771487064956; Wed, 18 Feb 2026
 23:44:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218200016.8906fb904af9439e7b496327@linux-foundation.org>
In-Reply-To: <20260218200016.8906fb904af9439e7b496327@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 18 Feb 2026 23:44:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjY6+W+E7oVEZDUB6cH-HN5nUzEn_2R84aT+mJoYUM+tw@mail.gmail.com>
X-Gm-Features: AaiRm51-lSIF1gl1yENxwN-64AXieqI8d_Mw3Zg5Jo88la1acanf7LSZ4kfat6I
Message-ID: <CAHk-=wjY6+W+E7oVEZDUB6cH-HN5nUzEn_2R84aT+mJoYUM+tw@mail.gmail.com>
Subject: Re: {GIT PULL] additional MM updates for 7.0-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Feb 2026 at 20:00, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-18-19-48

I'm not sure why pr-tracker-bot doesn't seem to react to this having
been pulled. It reacted to the non-MM one.

Anyway, here's the manual "it's been pulled"

             Linus
