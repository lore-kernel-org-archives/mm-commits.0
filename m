Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF2E20E3
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 08:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798295; cv=none; b=X4PblmMHINdUz6hRiRVwED4V7dF9J5EotcsWSXKOBGBuFCJMp9r/W/joNyPZZvadFysuQ3CIDQ/mgpsNxEVRsDTT+6N8y5TLmBRdheizW3XA8eTVCnawmtdY6b8DDSHH/aQ4bUrieqSED54F+qmELVM4Qi1YAhFXmoF2Vy9BoK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798295; c=relaxed/simple;
	bh=bqWnjN/SUQKeGCoWGtHU4a8gyskwj0hW7hqLD/zXP28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BotRltc6WuETIMkQebON8Cr2wzG1ctAGEQYdAjJ7/Xq5MatNCkIMWVOjlh1Q8HpbA7C0Xv2NexkPyQraVQ7AHmAaXklYOHmsgvPDNnyBl2rvvbIGX1XfToXDUeZZhAiJRG1Zq/1Qq8iTmmvRb23sGjrIJCMrJM0XVjPSwEF+lv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wlc+BggE; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wlc+BggE"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7b0c9bbddb4so1220199a12.3
        for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 01:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723798293; x=1724403093; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqWnjN/SUQKeGCoWGtHU4a8gyskwj0hW7hqLD/zXP28=;
        b=Wlc+BggEfUWDR5J1IzWwgKwCxKyXCKgFi+fCOAAmxL1lNRby+5dg38/dL8Sml4ErEL
         DsxnL/9V9uqK1pmDbcwnq3hUJqD0RCQORHZ6lbTxplVlF3x97ZVZiseGljsgkn711n/R
         6whkNUJjObom/78ZU9jwKjEYXu9XgIgMqfUtuoYMQ8hCpe7sG8GnU45PJQVD1nE6qkrb
         9/NnY5FybCjUulV6PFMBB5N+mymI/DC5y9DKNbM1cJ60JKGV4PKsF4r3/9PRujVjss/c
         aKQX1fOOQhiDkcvEdKEROQ5ENECBkBB0yvsHYV0wnkLKFSXXfMaY2ZkbOWtPvI/7ydpJ
         rDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798293; x=1724403093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqWnjN/SUQKeGCoWGtHU4a8gyskwj0hW7hqLD/zXP28=;
        b=jyxzBpkCh+MR+In1IVMDELak6wWmY39Cov4k4WKEEGRcjvqfg+17VmIetO6f542agy
         ire7ndVlamBcIAJ64d+bMbG+Z5VZrnguw8+3xJCi5F4jank+7u/MBwGtWVWASLrIN9dw
         b/yStM0vJ19siunLOUq9I1IQSCwjrzeVe647e1KDGyP5UQWzzCy1NbWcnQjs07uW4S7M
         MycE6goqDHlKLxsQg5+2S8Ldv7Nl2uSdSQ0lji28rc0hcyrsOwXPfz64ZCKf7pLmGepg
         YnZYfooX7yH5zdMJqY6kaIbLjoMCqVvni0Af69IMlExNnsSuGCoAfxfvgLgEsSFWW/v0
         LlKA==
X-Gm-Message-State: AOJu0Ywe7ShIoyBakEfKqz83yafmICR56Qvgt/niDO6tqIQBPHZs3JEg
	e5ufMHBv8q+udmp5BtFFEAA0g/IyZDr7qqV0/I6YktUmmJo9rJ/18WldZMa0k/ja9XUffjYiCQ8
	5gcFULi3OS0EhfmZ4lXucq8vbImI=
X-Google-Smtp-Source: AGHT+IE62VYpg1b2pyg4sIR266mCSYMxtp2mlF67K/tY9hmxX6MHK2u1TRl+VOmANjgQjIJEHqNtVkpbjE3wqz2Fii8=
X-Received: by 2002:a05:6a20:564d:b0:1c9:1606:89b2 with SMTP id
 adf61e73a8af0-1c916068b65mr1723892637.0.1723798293441; Fri, 16 Aug 2024
 01:51:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814202725.5BE36C116B1@smtp.kernel.org> <CANiq72mOivuUg_S5KCmrh71d9Tk49LaaCWjgxLFFNAs3dZWQFA@mail.gmail.com>
 <20240815141952.4c400e28e50494f34bd3705b@linux-foundation.org>
In-Reply-To: <20240815141952.4c400e28e50494f34bd3705b@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Aug 2024 10:51:21 +0200
Message-ID: <CANiq72mv=vkJ=Fy2KARKf9aFh1K-WNaXuOoZcm3Wm1gin0apeg@mail.gmail.com>
Subject: Re: + kasan-simplify-and-clarify-makefile-v2.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ojeda@kernel.org, andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 11:19=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Sure, go for it.

Thanks, will do!

Cheers,
Miguel
