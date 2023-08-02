Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35578C04E69
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 16:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjHBQTp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHBQTo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 12:19:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4AC19A0;
        Wed,  2 Aug 2023 09:19:42 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372FY2DQ031974;
        Wed, 2 Aug 2023 16:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Lokqt3xUJTMwgPMRHaFCU1TANle15V+g0Ht0TQxYXiw=;
 b=AIEuZGp2nBjAFGjhfeHspYoCTi9sordrj+e1TwV2IQsmo75LDMM6bgRta+12hQc7TltS
 BHlGCwoN5Y3INkZyDus/Mih82LAT1/QHabK7u2TIqCQJf1fLd83qfPT7lmOzXQDHftrL
 JBSxO9qPL3qQeLOSJXJBqtAsnpJ/Fe+rdNJTZstmhhTp9rnUuRTEvyYEYAwcpChYyVD3
 SkImXYwKbjbut6kJrq/y3Sta4mAprmq41PP7yXNhhiPwdlPGWz2xeTwam4Gb5Kx7Jv3k
 TFKcFyPJ6PZSyI6+vPSM41vWFvwBu6k0y+GxJqmykuSDdhYq0srNFwpUufgNff1juedw HQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4ttd7s6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 16:18:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372F7tYv003964;
        Wed, 2 Aug 2023 16:18:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7e6ee9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 16:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYtUhvLor8cNB1kmFeEnIZn8XXV2D/m/19CQwluwBV3d8ysNdb3xLh4i6CzpRWiHxxONCzrWgqIFr23+4HKSyjnTChuJpnw071xHYUXNukaPj4+1vBhKDah5fXSfSZG3iOdxPwsY7uBldDc9t6l8vc/8YzMEgAsHFABSjagEYjk3N8Feah79aPIC/4cHuN5Y+Ojwobt3sH0FvIttRrqvTO0OmcGTY8UlAI6Jau7jqyO2QQvaM39AMisV97oEaH2cf/HvKSvOF/8Dh17EvKAGZgF/lHCq2nLGxhI01LdPwBdVc+stLfE9gpjNXNYWhM0XoqYmZBMl1CRb5HscVqnldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lokqt3xUJTMwgPMRHaFCU1TANle15V+g0Ht0TQxYXiw=;
 b=ifWHO60AJxzIs4ax+kTqkQyRUDPexKqz+OWzXkjS75B3E1g0KdT3/zw/hIDXlsJxpEGm3YOB+NiycAS5cR3U0PCEWdm7omxmczbj227m0hyDxAZ5Opn5rkWzW/6HszjCPx13fakOOa4NqUCUVwGpmVLBoRFqEfZMxfKxbDxZBIE/eof88kFgu3Gyp0eEMFnT7ShtBITZaoAr1+SyAne8DJ4T4SNbxjnWaH/PjkxQBKmxfhVpU96kf6GzWo1v3sUkIbVTA4djgdZauKxgXHzKI3z4tmwymVEjDTy4S4QjLHp2Ef9oEjFn8QUHNNXL+mWaXiymvq2bZIycAedAcr2ObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lokqt3xUJTMwgPMRHaFCU1TANle15V+g0Ht0TQxYXiw=;
 b=i4WpOR1BeGR9SmA70Q5k8t6MapSpl2VDKzY6f/0k2eBtCg6V+KwzcNqnvtf7UMVxSsrO50KNBvJNDs8HDeKTuVb3+uWmz3LCmGVPFbv3uM4Qlibfi3FRD03Yv2Ek6uMkzwVcbw6Bgt0lvxZQvYHP8gi/ZC+NlLSUoUD93Tu9aVU=
Received: from CO1PR10MB4531.namprd10.prod.outlook.com (2603:10b6:303:6c::22)
 by BL3PR10MB6068.namprd10.prod.outlook.com (2603:10b6:208:3b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.19; Wed, 2 Aug
 2023 16:18:06 +0000
Received: from CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::9a1:a343:e04c:5150]) by CO1PR10MB4531.namprd10.prod.outlook.com
 ([fe80::9a1:a343:e04c:5150%4]) with mapi id 15.20.6652.019; Wed, 2 Aug 2023
 16:18:03 +0000
From:   Eric DeVolder <eric.devolder@oracle.com>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     ziy@nvidia.com, ysato@users.sourceforge.jp, xin3.li@intel.com,
        will@kernel.org, tsi@tuyoix.net, tsbogend@alpha.franken.de,
        tj@kernel.org, thunder.leizhen@huawei.com, tglx@linutronix.de,
        svens@linux.ibm.com, sourabhjain@linux.ibm.com,
        sebastian.reichel@collabora.com, samitolvanen@google.com,
        rppt@kernel.org, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
        paul.walmsley@sifive.com, paulmck@kernel.org, palmer@dabbelt.com,
        ojeda@kernel.org, npiggin@gmail.com, ndesaulniers@google.com,
        mpe@ellerman.id.au, mingo@redhat.com, mhiramat@kernel.org,
        masahiroy@kernel.org, linux@armlinux.org.uk,
        linux.walleij@linaro.org, konrad.wilk@oracle.com,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        keescook@chromium.org, juerg.haefliger@canonical.com,
        James.Bottomley@HansenPaternship.com, hpa@zytor.com,
        hca@linux.ibm.com, hbathini@linux.ibm.com,
        gregkh@linuxfoundation.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        frederic@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
        dal.ias@libc.org, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@linux.ibm.com, boris.ostrovsky@oracle.com,
        bhe@redhat.com, arnd@arndb.de, ardb@kernel.org,
        aou@eecs.gerkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com
Subject: [PATCH] remove ARCH_DEFAULT_KEXEC from Kconfig.kexec
Date:   Wed,  2 Aug 2023 12:17:50 -0400
Message-Id: <20230802161750.2215-1-eric.devolder@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0334.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::15) To CO1PR10MB4531.namprd10.prod.outlook.com
 (2603:10b6:303:6c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4531:EE_|BL3PR10MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: 694ebb29-43f5-4622-989d-08db93740b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMsVRDmNFpDsVk2xyjEvWTOSAU1BXgW5pCU9Or1fse9gqWqagbSnilLf+emEpaAo/CVYIvkeTMeiuMbAYLzKVK419naBBbCFa45hFOoP6dEy6DcY2/nIZbGKZuyryVgT3fgky2YWQOtTzND09Iav3YigBgsXMAtAnbgf4iY9X+DL4jwFpW35YGJQcLppqz+4w2waY3XICcPG3F1kHaG82QnZIQQq6fE9JUJeaIlY6vp9s03/RYl7BkQCLgw12GXGPKo9ZaK2Arn4mLmbhsNMmeKYiV/KM7gkTvsw9wOd8DZdFL3ja0Uxpi6zevgH2NsPBN/9A9VU6IjFZca4aTG7IrvfG0wmpQlNvpflqRQ0ukHudYnveDwtU/spVsw4pFqqLU5T63evX1b0xjz4ceFO5U/awSwpS/lPsywWCtYpmfxpRNFP0hXUxUT4+AIEXrAUYnGtN5gj0NYQCsdWibAriBOhMO/LIg9AXnYBJSRyv3z3BWdd5E3eHHiRcQpI6t+fFuiFUcssndz8yBstVpZwcW5po4YNHELauRc3hRZSvMKBYpmWe5Zg66m4dMrIokm8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4531.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(36756003)(478600001)(86362001)(6512007)(6666004)(6486002)(8676002)(8936002)(41300700001)(316002)(5660300002)(66556008)(4326008)(66476007)(83380400001)(7366002)(7406005)(7416002)(2906002)(38100700002)(66946007)(26005)(1076003)(6506007)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F7tJiOu97BNhbyYVhwQAhKs3fN4XehzJosifKu6IK3ry2S79NrGitYLLZyFD?=
 =?us-ascii?Q?PMNzbcOBxQYcgnNOEjzXS1KOnqXxZWLMvgZyXNphxZjkURz6Ulnnb6qgGR3C?=
 =?us-ascii?Q?9jcb5sysCj8qqeG0dymsndv7ZUbriQm/yf0e6kfJWBoJx4xkKnudVcLA+cUZ?=
 =?us-ascii?Q?VWkw1tx8ClVj9MOD4QCEu885bO19AX34PdA5QsL7TxiAgM7/Qzjyfm39E9VS?=
 =?us-ascii?Q?yRyT8JLu0fELO+19OLv4e2VMGTCGEoFCcehvg2mOveJeACsFUEIaCaLUNbsa?=
 =?us-ascii?Q?qWB16uMkJZR/oH0nnaqbzi6NCR8rXkWR0353W81Y+KDlrqi1MfIlel4k9ELg?=
 =?us-ascii?Q?TZEnoPdiPbTAS0ecAtEYRNUyPgTpSZYmur++eP2Ees/nxu4c+zWWdBoY67pe?=
 =?us-ascii?Q?n2WtbfnibnP/iIOVJ7pdnQaRS3V2Cy+vygI4QFJKPxt1ys4ycVdvnJFQ2DFm?=
 =?us-ascii?Q?/fknSBjSOd42BDFgqmUutPyoh6y0bkgDodRl1iFMZyEufIouF5w96PVrBQ7p?=
 =?us-ascii?Q?VuHffUqjQr0mymYt7M3uoeScp4BCTycF+wXj0NzoLQxuwjVgzVKozafS7yV8?=
 =?us-ascii?Q?3+lC2ywBBMUMqmETkR/+WOgSJ7M/PcVO7HKgxmYEZdbaAlfPZqQpJLRILHXz?=
 =?us-ascii?Q?tVKikCEaKc3vZ/aRHFF7WIBPPXU6mPy8uwBStdhOaYOmhqy2fNxfltkr9g5H?=
 =?us-ascii?Q?+FzTU71vSfRwvk3u04gUGfA5zmSPt7Bc+WAOVdeKjM8tUZzHWStsNwWSL3YM?=
 =?us-ascii?Q?LIQ4rl62R1GKGpkSg0Ne2IZTMwkvqjktCOFiyfM0ymjU6USmY4B+h+ayKvbu?=
 =?us-ascii?Q?ntW18L3N0F8wbALXTUAMkPqD3/c8sQll/dtFQ6ww7VyKi/j5n0PZHNlg8zXQ?=
 =?us-ascii?Q?FaiRlbybGNXBZHftO1eL6JsiL/QPOOTXfVkmyeGv5gplJAAyOq8yODwspqSG?=
 =?us-ascii?Q?rYJZxeqZ61GWvtfojrIQ15ZXhv1m1g8r8xeeKOWEvqvszlOae2R6XTL4cX3L?=
 =?us-ascii?Q?VNcU5ByaeiPUN3Ud2CnyGPuoRE3bZ/2gbUaOeBA4+5R7d6ZKEEtGAB/nk6qB?=
 =?us-ascii?Q?FkmE9jbCBgVEz5d1clcH8TtfSefDYtil3QIyiFs+GypJlWYR1diVA/IcQUkP?=
 =?us-ascii?Q?mGhLRN2qbmpN+O8EgRsRsf/hyFkq2+YpQTBR0LbaBYOontrEn+r7VzLZXRxH?=
 =?us-ascii?Q?TKlTgNKe4myfmMlX9XznBlWRuqFeuPV/sR8TwQ6w6ftkGZVm6zDyOwqRrksV?=
 =?us-ascii?Q?s8w6pBtoNQdL9+I/Skr6wOgRaVbG8/n48SYLuYt67rGW5J+dsKnN+XokYDR5?=
 =?us-ascii?Q?VUP/wqTJAfuRwhnhvMkdVBKcAsKsYygOoMJwUUWBTdViZrL1w74T4d6R9ThE?=
 =?us-ascii?Q?3NHkqF1sbByds+0A9oLkWavgVXArEgqkwa/2V91DgPhp2hLZovmhTHHxRviI?=
 =?us-ascii?Q?rKrlqdd73aoGsf1bJh2ua1zFVXwQb8HW03DZBCqaf1dW3RWTKVrXI6E+NAnH?=
 =?us-ascii?Q?PbjJ1mfT7DYJBGrDHXNKDCpqymmCu4Rth7q55GnQX3T+QJBXHWXxbOh3Xvyy?=
 =?us-ascii?Q?7hvIOQECPCuK7Z0xAtw758UdXLWqr3WeBzVt+lQ8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?RTuq0DIK5z86SGujqc68fEpthyN6/Fy48NcRPior9EskffEV+HN+/1HvWxhD?=
 =?us-ascii?Q?ay3aA0NI1YG+f+ByD86exlvNOc96FD17GSyLcBYuDFYgEf3QRV1PsFR7QgW2?=
 =?us-ascii?Q?aVwYB1MnAfaE/9fIRZjvYRqQJCcCua2+IYeDeNwycAlK1rsqeGfP6aiFei6a?=
 =?us-ascii?Q?mI+6exorYm5nYc/sTZQ6fkfkdzKfGg+X7WTGdRKzhz73ygilIJAQgtTgqSOC?=
 =?us-ascii?Q?JfttyMGNwLNPNqNzU0y5KZlbyqtfJihuY8xEo39sahDEOcy0PPECrUnCYS7T?=
 =?us-ascii?Q?r0/JekFdtH9MOuKCNF9MLFuUtpR3P4At/NZjYp7mgQklTQ0jkfMnRfRtshRT?=
 =?us-ascii?Q?Hp1LgVuSIfR5+BNJxWtjUJttyDjAcCNTbCQi1pKjF9+akwaKizTQm2wziHT7?=
 =?us-ascii?Q?JtByyhwgct2RapC9/rDhkko8VeAf3Qz3UEFal+fBZkU4Y9mRwd8q23UUmw0d?=
 =?us-ascii?Q?Jv2nnFzTVn6Jmo5ccXYFR8CUwySKI+q9DjQ9iSXgKtgVLK8pPdHDRfKOy1Sk?=
 =?us-ascii?Q?08omRMq5rIXJon98w6BVTDHdZF6FHryfa8tqQAGiz4dJwGhPCSjdbEHlXj/K?=
 =?us-ascii?Q?sh9oARR/S33DIKzu9Ic4REvLf5OJiTRNNC862yJXxpKuQv5LWlb/Tg07vZQs?=
 =?us-ascii?Q?KK5t664zJOxLRqX26ht0ZZHqCzT+W8kYt/GDbwn65+M5XgCmx9jEm6MPfzhp?=
 =?us-ascii?Q?f80WhUm3m86F6zBZ3kBXkEdx3p7o0yXKGoGOviX13a4kudnSGa9oNaCM0ukX?=
 =?us-ascii?Q?anUsGDktyZBKdvZ1FX1CRefLugwdUeaiwRkKloiOD+U5RZuPKYs2dd14Gj25?=
 =?us-ascii?Q?PTtmPggJVfaNeoXS+NE8QU58M7mkl0n5jb0qogkRCeHL3Gu09IopL2n0xwEU?=
 =?us-ascii?Q?YISau5SUwY92pe0rcn1tBsuU9Yx0tAUpgkgdVplCMi6kiWz9iHXQ075ZpzLw?=
 =?us-ascii?Q?5PZZJUb9QljU2VTRfRqhe1Ya1rp/TqEv92r9aygAyK+wi3qRB7cWasmM4cXW?=
 =?us-ascii?Q?LDyy+QzybDNs7Fa7+SXgTZXsCOtQLPR7luOPtXosrNa4z1MB3XMx8jdfYFbc?=
 =?us-ascii?Q?Qhbz2zT3ccNg/3i3umiFEFrBIUXe/kTjIrtx87Yszv70tXeAM0eQjvZZZPny?=
 =?us-ascii?Q?4yXPMbAOP7dhBHc2YJYc2KjSZTbEdLr/o1MGnQ0o5FdXBqQ4aXuQQQ/IQnM2?=
 =?us-ascii?Q?FOS76xpthc70OZSdS6aMOdBPFqDLVo8L14fuopNMVLWN60VOcXcu+FH2GFaA?=
 =?us-ascii?Q?gzGmxGPLbBndG8W1nGR+BvQOMUSBgDdm58AF3GXJZQXR45/hdZpl6GegJbXb?=
 =?us-ascii?Q?n/MUJXMGV5TjomMcbbIkY/pd7VmsLnYYj6hqLI6wPqzQa2AjJszuiqoz9Jyp?=
 =?us-ascii?Q?9JKJRnHRKxt4Hx8AaJ7vSfqHPcikDCz+X7Ehu/p3gs3SmLjwaFwmuUPKJM+H?=
 =?us-ascii?Q?njRt4iiNVw/THQmZP/HMcsPKHfHmPXSNEdAuvF0oX+wM8+gfKX1mLavYDbV9?=
 =?us-ascii?Q?Dp8xjPFwKgP5pI3qp4drstv73IeqVRbxZth74bbGS0Le+EHbpYDd7VKlWEKa?=
 =?us-ascii?Q?CL1/sAvTg6fwllKBF58rRDXk0IwurC1mNaZmWcva+90q9jTCSVnm89cIoEFu?=
 =?us-ascii?Q?hEMK/tdfe676+iw+G64ch2Kmc8jxJ0GfXjPo9FaPsULmxNQA6jaFfIo30HpN?=
 =?us-ascii?Q?xM23/kO+HQM1ZEsPSVNWI/ACqEqD9y+7nW7Y0aLDqKym+VCubVO+6xxwOPF2?=
 =?us-ascii?Q?UPSeBvF0QPCPqGGeu9KXlVKKVGrAc//wssSX7s0Q3Nrnd6DUmG4OQLMCcJGq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-1: YBNVU2of2CLULOKceOfor2W2k4/cl/zeD8nLHpQqVdCkoHgJkju3SmVobcCfZvSf2Dm0eYrehesA8fCyUvrVzbGR9MNvTnJmP6kytqJf1X6W2LqlysLcwsWtDuYxaId8XYrT1NTVzZMTiZxHTltEPtVVFAJ/M0GNRCowZrLOBOk0LQambs4xFHZ5GwSp390gusk/bLjWJJwpriklNpz5k5mylq5aIqbwFEPmvI84yyIvbxwjeWsc4GO5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694ebb29-43f5-4622-989d-08db93740b3c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4531.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 16:18:03.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDA1tWQGHGiKBzL3D1YTrNcp81uxtjFDYvKsgZog5NhTuwEnp0+X3x+r5n1ZrsYFpV7MonzciRfbdU77YDqh4NO/06K1PHY0aN9vw08FEII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_12,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=888 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020144
X-Proofpoint-GUID: cz3Xl1uELLk-QIUHu9D9T-rl2wj7HiFp
X-Proofpoint-ORIG-GUID: cz3Xl1uELLk-QIUHu9D9T-rl2wj7HiFp
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

This patch is a minor cleanup to the series "refactor Kconfig to
consolidate KEXEC and CRASH options".

In that series, a new option ARCH_DEFAULT_KEXEC was introduced in
order to obtain the equivalent behavior of s390 original Kconfig
settings for KEXEC. As it turns out, this new option did not fully
provide the equivalent behavior, rather a "select KEXEC" did.

As such, the ARCH_DEFAULT_KEXEC is not needed anymore, so remove it.

Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
---
 arch/s390/Kconfig    | 3 ---
 kernel/Kconfig.kexec | 1 -
 2 files changed, 4 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 42c98931de2c..c9e523e0d997 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -246,9 +246,6 @@ config PGTABLE_LEVELS
 
 source "kernel/livepatch/Kconfig"
 
-config ARCH_DEFAULT_KEXEC
-	def_bool y
-
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index ff72e45cfaef..701cd5336f4f 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -17,7 +17,6 @@ config HAVE_IMA_KEXEC
 
 config KEXEC
 	bool "Enable kexec system call"
-	default ARCH_DEFAULT_KEXEC
 	depends on ARCH_SUPPORTS_KEXEC
 	select KEXEC_CORE
 	help
-- 
2.31.1

