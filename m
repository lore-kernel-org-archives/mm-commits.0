Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB35224CC
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 05:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809033; cv=none; b=mYymaSUG0Gkcxl56FKQWCngiDKamNl6rgihn6iYAB5prmCzYSx5HY9lFQ9fp04McM1PickqwgeOZ2jXA26ZPX3cigL4bWzTyvil2rPBlC33P/0fukh2wma6xk5ThKney9SDnaJedYcw2enyw9Sl51VHZ0KZLbDF+vKxdgHB0JvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809033; c=relaxed/simple;
	bh=aTjOK/wPe0ItsVsha/ExeZ/2Uz5Nj07sS4vX9Hvgl3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeCkeIUjm2iaCtTzhLxDAxpFHa3wbEpDiKAgy/yNNHfrB0XvULmq0Rpg3jHdWn9YJHOGZR+Vr6Dv4cKZainnLPghImWYCZb21KlZFtSU7+/9hUmVh9dSwc5SE2Lyrn2Ma8uhSZOYK1eIhY5LPTuEzpgt4B4/jaxBc397IOrMtPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=IDAu9RDc; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IDAu9RDc"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-725dac69699so2015617b3a.0
        for <mm-commits@vger.kernel.org>; Mon, 09 Dec 2024 21:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733809031; x=1734413831; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DA6LwlN+iu99STnfx1xnRTypt6Y96GDmqmaEft2Edrg=;
        b=IDAu9RDc/k0d4MUYfW3yR8v0NhjqWPTNsrHtmrJo2ecSqWuTYnsDIIeJ3r1PBf8A1z
         KsNQUnx68uMD191RFfe2BY3SXkigDi5PzzxgCSqS11eBjhzKRv2zo9qPFug8o7WA5o1H
         tZgGG1s+YHRzOtUahkhsYUkF1DKJ32Wh+D45E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733809031; x=1734413831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DA6LwlN+iu99STnfx1xnRTypt6Y96GDmqmaEft2Edrg=;
        b=AtHB+L6j+8xO8XmewOTpTGQITF1CfUDpPCgi05Q4anRoBL49i3vzqYSFwT0Fc148Zh
         9uJyf7c9e4Etp7p0uGkLYvDi14cUbivoj4fdD6ilsimSwHm/w0wI8h0HSzHc3rzLfNA5
         GhGNpFaJR3j4ggHB9k8bJnNPAdGxFNaeIPjLupeHfDNuqmdlEgHSPaJvAQ8U2TZEIiQE
         eEOzVJl7hE7lEtRWu/TuS+Bk5a3SQ8o8gN1+9uPITLWeBy2gcwDNR1XjKDElpqjffrfD
         DQuU+sB3hk/rxbN+N4TQpiS9Sl8GRdxQPk9TtJYY4KoMVVetFjVvuYi9+7xQw4Sqlvkk
         QTpg==
X-Forwarded-Encrypted: i=1; AJvYcCViIQ7kHv3dY7l74J/ABbasaU7r1UBjTDMBadZIUDtOQaBQvx6kC2OlTYdpuJkipwt4hvFsYvbm0xVg@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbl6grI7r33Djr+oQGVvgbqstD+hdC/lKUQHW1vjqNdWa9YlW/
	BZ8qx8jUQE9t5uEATyp9HLAVtuRSIOOAsfs9RNLU4J7diILjyUnJydFhk7V+Sl6kV/72caVbXjs
	=
X-Gm-Gg: ASbGncsXPOhOd0HosHqxmiKAJXwbsorC0xHOz07iUAq0HQdDf6QA7uzm49rlo97cX7u
	gO84boAxkwG3+wGdHJImFKbT2Q3jf5SHidu9AiTn4XmppDJD9tC5oJKDG3W16HMd0eF0YyLJrpC
	RcX7cDi9Tzq3c7Jq/5R2EXtAigjMxg/r2a181LbpSaCysyfuX9h73j3NQukBkcLFxOq2vVqWDvF
	xE9IxCbNz5KBx6izvqSHw0vSV8Nr++BvdamjqVDOs8Mil6FshpFPqWcpA==
X-Google-Smtp-Source: AGHT+IHsRdrbt4UaD7n1kcL4kNxd2ePBm+Z7OktgexwEA0DthXG14ae04j5UqI4+aDSqtlTTyuMbAA==
X-Received: by 2002:a05:6a00:22c6:b0:725:9edd:dc30 with SMTP id d2e1a72fcca58-7273cb1af91mr4786542b3a.12.1733809031388;
        Mon, 09 Dec 2024 21:37:11 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:ecc2:3f01:a798:5d0f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fd40e37fdcsm4231258a12.53.2024.12.09.21.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 21:37:11 -0800 (PST)
Date: Tue, 10 Dec 2024 14:37:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	mm-commits@vger.kernel.org, stable@vger.kernel.org,
	deshengwu@tencent.com, kasong@tencent.com
Subject: Re: + zram-fix-uninitialized-zram-not-releasing-backing-device.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20241210053707.GK16709@google.com>
References: <20241210015750.7D4C6C4CED1@smtp.kernel.org>
 <20241210040815.GJ16709@google.com>
 <20241209212039.69b30b998e5de7622fe10ab5@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209212039.69b30b998e5de7622fe10ab5@linux-foundation.org>

On (24/12/09 21:20), Andrew Morton wrote:
> On Tue, 10 Dec 2024 13:08:15 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> 
> > I'm not sure if this and zram-refuse-to-use-zero-sized-block-device-as-backing-device.patch
> > are worth the stable tag, they don't really fix problems that people run
> > into en masse.
> 
> Me either, but they're very simple patches.

Fair enough.
