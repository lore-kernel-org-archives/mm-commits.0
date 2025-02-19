Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0573E43151
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 11:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739964508; cv=none; b=BQy+dyDyFeTZO4DFOQOAUUaNLi2AIU+nFLUWEeElIhMRRpBleYyMwP1VtZBgWL4oAXhHVOZArDbA8URmCJlu/iLvRDUlaMZlZ3UFmQdSDGQyr2qVUfahktTw5bMKsyWfwVvM5I+92pJ/hXVTDyUSuhpXYGZvQzKYByrXo0tuG1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739964508; c=relaxed/simple;
	bh=Nq+vle5wWZTD8b9+O3h3IP/17qeIXGp+THGRn8qgUnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ast/lHvl9Ygjghd+7lQJB/fySVX7WUlNrkaHBDNSiMsQsjDXcgvnwq5PZpORqaSF6QcK5pyq/F8vqVy0EMvBplxuqqTLxUG4oqFvf+oTp14QE9dt5zfvE6HuqEA6Ucv0SX0rbytGidsgDAJC094VI574nl5MHaiwDsE62pPpEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G6ZhK2DQ; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6ZhK2DQ"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5fcfeda1040so334809eaf.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 03:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739964506; x=1740569306; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nq+vle5wWZTD8b9+O3h3IP/17qeIXGp+THGRn8qgUnc=;
        b=G6ZhK2DQrkOvYsP7HHj30In/VWqRJ7zEk/Z4qud9rJXzPipPCxW1wnn9I6Xu+F6F+y
         T+Ffdt+wpU5NJSX+NIczhRpTFxWRynV7o8pHde867WolbglZbjhe0v6Hao5+D3noTQ51
         EjWK1ysluk6qImD9Ag5ei8RPBazvEeMijjSweJ7ECaRpWcLdj2CbWT7ku/aoAy3qqb6H
         IWH+At+XkpsD0qPGXIF6bHR3TRNoUq9B4DCrq6kkKgQaXycnWCO+wgpVn5gujfwGo3TL
         NTYSTDzkTJUeGbhwFhSnj0DHgSL7laQWYqY6t8X0PBm78X9N1bQhBsdZyo/0gD9dgzIq
         sJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739964506; x=1740569306;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nq+vle5wWZTD8b9+O3h3IP/17qeIXGp+THGRn8qgUnc=;
        b=WoVOFlDifoE1d1ZzVahAAf7HxaFSKd6Gs7e9N8oBAEfl07W7xcE1RvG0Nkb4+ruRLa
         MAAvuWdL24HmxWeh+Us4Qwdui90ax7ojquKVWJT2PPB5nm8jF/yyJH9e0RVQGNK5Gf4y
         aFt2+F62cWd/gi1LwfJyM9Me45y4mE9n6NziwDs3HsG5FzTbunCnIZpXdplX6hJwFy8Z
         INhSWkp/GEy6cYZqTsAVW5Inw0sBQlV4vCB//HheiS4Rq5CXL0ukvDSN4nthk2moBDug
         BxPr19vUEXA1ulOB6bgSUYsJ4UZBQbFPRms6598W8A5NAcs7Hc05U/a2z59HH3lhsMR9
         tIcA==
X-Gm-Message-State: AOJu0YxK7+NTTfEkRxzFb9HIs2GyjaQzm+fryYSRH8JMbOxJxi4bGcXq
	g5Alc+Mu5LMK5XRDYjhRSvYAUFzWy5xX1Xcs8MLxJ5eL8XJV0rT74yjdzIUsoGsx6gxQ2IlxxdT
	60LGOX8j6MgUPJIHLxVECNrGr2T0=
X-Gm-Gg: ASbGncsGPK4wm1s2ouUnP8c6ltuJoyw0K+6Gr72/3vdClnbYzzCIsDsGEH9mkh5XBgC
	n9j8iVzrKS5Y6111PKpaQ1NhJ/Ur6I979P/RqW/9c6TrquQiBQ88RiiExlI+9gbcsUDfRqa50v2
	xyWS5SEsHPktZEKA==
X-Google-Smtp-Source: AGHT+IHvW8ccnsNo33doBuTkUgbBJKQgrn7BtYeNRr6JBx6f/SlBuTFh/KBguHyFC8hy3kajHKH4ZTQJkwXiA9atE4M=
X-Received: by 2002:a05:6808:2e97:b0:3f3:cf73:3e40 with SMTP id
 5614622812f47-3f3eb0c63eemr13685944b6e.17.1739964505613; Wed, 19 Feb 2025
 03:28:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218042407.5B384C4CEE2@smtp.kernel.org> <CAO9wTFiAphJkat=64R9EmWC+SqQ_ysmyHDVV30E+sHLhYt2_Rg@mail.gmail.com>
 <20250218142603.c16ee5bf2148eabb411e9e0e@linux-foundation.org>
In-Reply-To: <20250218142603.c16ee5bf2148eabb411e9e0e@linux-foundation.org>
From: Suchit K <suchitkarunakaran@gmail.com>
Date: Wed, 19 Feb 2025 16:58:13 +0530
X-Gm-Features: AWEUYZlDEAiwmrGo74sGMrcHZ42eZUY1AqgGXUoJ58E1b-Nu4mGli7NqtLA5dw4
Message-ID: <CAO9wTFi3VVy3BagGFafsLqqVc5RwTDNHghRoHuOKCW8mWDyfJg@mail.gmail.com>
Subject: Re: + documentation-mm-fix-spelling-mistake.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

Alright thanks.

On Wed, 19 Feb 2025 at 03:56, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 18 Feb 2025 14:18:42 +0530 Suchit K <suchitkarunakaran@gmail.com> wrote:
>
> > Hi Andrew, I'm not sure what my next step should be. Should I find the
> > original patch message and reply with something specific?
>
> No, no further actions are required.
