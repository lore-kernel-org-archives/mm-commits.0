Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D95FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 18:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJTS5R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 14:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJTS5Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 14:57:16 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FDB17D285
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 11:57:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id u71so390267pgd.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 11:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFG8oe8zjIP3HtrEYf8FZ1cCVncWHGDhPegdRUm6pSk=;
        b=JH10v71f9cO/zrGHhWXMzQx4+lZEXvmFPiD6f82j66NBiYRArMO6WA87v5WRzOFdmJ
         vFAhDRdieYSaEwIMaX4NLT7dRZsmxrRodnE3B2inGJhsPNES+Wrq+P3EMm9m7qfLm7+X
         VDQRrM3G4guBVWiBNXcjYnt5uMWuXxdXqgHv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFG8oe8zjIP3HtrEYf8FZ1cCVncWHGDhPegdRUm6pSk=;
        b=mCQs/iNvwnVM60ZUXbPFKodoFYWj4szmtTV5HCAxQuT70GIDKdsSS8bTSDeLFj9SZ7
         6xnVgdvdHbDH7LZ3oQN6EHLOeyn+GCXjA/BxndA1goMxPWsHKKkcZ4Ci9EmRRCrXZ5X4
         JEjCw1cy2aWX4EZBktHgGLUPfOo2EGhaZvNmsyHc2DIdftRD1dat1AE2koNmN52Q6PU1
         JNriu8f5X7+2yXeksyks6Zd+T9Oh2TWgVyqZYa20/Uj7Ro9aUiBFr7pAWOyJ9BxNgVSr
         fabZisux2lxGlSUXxCqQmB+gmz8OOvjJXtJqvaNc5cRNA487KiI2KLl1fh1qVHkeN4wg
         MXpQ==
X-Gm-Message-State: ACrzQf1OBI33bzP2Ux929TAO8+ngIh9NqIrtCJxSEOs+scu221NJWxH5
        FTdUsYjVEVEhKjSzAyNfOV2BTQ==
X-Google-Smtp-Source: AMsMyM5LsHsFEMX8I6dkcpYhAJP8fLYRo6gtf8HpJpwWxcUentkixVPXvC3hRVRGYAOeDT0aPDAVFw==
X-Received: by 2002:a05:6a00:1707:b0:563:235:769b with SMTP id h7-20020a056a00170700b005630235769bmr15374927pfc.19.1666292234509;
        Thu, 20 Oct 2022 11:57:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0053725e331a1sm13669135pfp.82.2022.10.20.11.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 11:57:13 -0700 (PDT)
Date:   Thu, 20 Oct 2022 11:57:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, masahiroy@kernel.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct
 p4_event_bind::cntr signed array
Message-ID: <202210201151.ECC19BC97A@keescook>
References: <20221020000356.177CDC433C1@smtp.kernel.org>
 <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
 <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
 <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 10:42:25AM -0700, Linus Torvalds wrote:
> On Thu, Oct 20, 2022 at 10:33 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Or sometimes with objdump, I've had more success by keeping debug
> > symbols, and then trimming offsets from jmps.
> 
> objdump is what I'm using, and it actually seems ok on individual object files.
> 
> Now I just need to script the "do all the object files" and see how
> massive the end result is.

For the a/b build, I start with all*config, then:

# Stop painful noise
CONFIG_KCOV=n
CONFIG_GCOV_KERNEL=n
CONFIG_GCC_PLUGINS=n
CONFIG_IKHEADERS=n
CONFIG_KASAN=n
CONFIG_UBSAN=n
CONFIG_KCSAN=n
CONFIG_KMSAN=n
# Get us source/line details
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
CONFIG_DEBUG_INFO_REDUCED=n CONFIG_DEBUG_INFO_COMPRESSED=n
CONFIG_DEBUG_INFO_SPLIT=n

And to keep other build-time junk stabilized[1], I build with these make
options:

KBUILD_BUILD_TIMESTAMP=1970-01-01
KBUILD_BUILD_USER=user
KBUILD_BUILD_HOST=host
KBUILD_BUILD_VERSION=1

For the code diff, I use:

objdump --disassemble --demangle --no-show-raw-insn --no-addresses

and when doing the manual examination:

objdump --disassemble --demangle --reloc --source -l --no-show-raw-insn


My not-great way to filter out the movsbl/movzbl, I added this to diff:
	-I '\bmov[sz]bl\b'


-- 
Kees Cook
