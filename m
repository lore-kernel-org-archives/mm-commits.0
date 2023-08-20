Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E93EE49A6
	for <mm-commits@archiver.kernel.org>; Sun, 20 Aug 2023 21:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbjHTVwe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 20 Aug 2023 17:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjHTVwd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 20 Aug 2023 17:52:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBF3A0;
        Sun, 20 Aug 2023 14:52:31 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37KLZf3W005112;
        Sun, 20 Aug 2023 21:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=CJw8s1kwk0+EKAsRn/QJoK6VcYd24kSCf+sHlszNzLs=;
 b=02s2Iy1tbKp8ivxntw/+bTUWJmNllpjv3IYxTNzO16Mm08Ur3DH3AL4Im8lYPDbigfDG
 7GEbwfdo5RJ4blrK1ygLKEMNFZdOc5njFRX+hPxfIKTla1QTg40fDP33aZU0WHUlrCu+
 vtmuUR7FG1MsQR/QN4JNTt6vsQX7M9Y2p/QTpi+BZMwfI6T+X5j/OUjfd6bAD2GPJxCM
 xUh5ntYKSuFpTyaszkdbRztV8eOByT0UNeOWOubITYsKp1QO1wItqZkLoDcBM8LEmx5A
 7aTIJMvGxw15FtMcLhWCy9GRhj9YsCL2uE3rsRk3uK3hYSblGmiOIZZ+BYu1ya5ChSI6 bQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjnbtskvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Aug 2023 21:50:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37KHUMNx030392;
        Sun, 20 Aug 2023 21:50:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm62rv07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Aug 2023 21:50:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNQoqptPWYdBK+CwNoGQN43awCBDdEp5BQ4CIrA185Fy7k9/xA7xVzW7O6l5vasQpuLMmxc2vuJyPoTDfAiupJvuNX0qZvjUTHs9G0zqUOrqf8wgQKCxkuchPQWbuptlBtZfKE6i5hBH2p+3tVpO8godhBDzHBhjmQ/tdiYBxNWHneOY2IARAudLpEY9r8upYUVWXQVBgcsuXv4kwOVDOTOtWAYc8owBrixLdEX8t1RRCs3IP6xSbofjennCynes/uToGVeZPLxjOmPlSsKEOZG/faNczsLgoU7HbD/0yxC/0Sw5Y4CSguzCigFKFVN8nYHPxGxpCuoDPjd73+V70Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJw8s1kwk0+EKAsRn/QJoK6VcYd24kSCf+sHlszNzLs=;
 b=eeHAHNRXhncJTmC8f/Jta77I3kKj8CfSAp07P78o6AwpzVWMDf6Ogkhfshu+0MfW8KuKCxHzcrGE0ae/ahWk/0uC7V37SkMXHy5m1U42cSItJYVmcjIwSHXEb06XvCydYsNDLczmtPKK2+5vFwECeGZ8yBaydu4ckOs0PySGooHUhwY1bzectqElt3t9ZnzQlohiuHG6PYrfDXtUO+ZKK7U2hAbJpD6fytKLZ6iVfVSM+MVrz3lsZakCLj/2BK7rS68VG1Jl59v3swE2ewKQvMK4MnDVjU2ie/TZDyr6kSddVU2ilL70o9ogjAsMBfF5FROi9oP/52BQfVyNQ4gb7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJw8s1kwk0+EKAsRn/QJoK6VcYd24kSCf+sHlszNzLs=;
 b=t63E59YFlWIa1Yo9x1JM13ZTLbkIw5F00HYAhkYmvnWA+WeFO8GhsqKHQ9w8WU9SvyAUr/hp6Y4N9QSMc8RE9JGp2ChfXD3Z4vYhvDwFP8B6SmI4wChovJpzX859yjL9n4euH+wAgjLsZJ4Wve4tv9j7D7utJ6nuRjzmvCJ7TaE=
Received: from SJ0PR10MB4542.namprd10.prod.outlook.com (2603:10b6:a03:2da::19)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Sun, 20 Aug
 2023 21:50:39 +0000
Received: from SJ0PR10MB4542.namprd10.prod.outlook.com
 ([fe80::1aac:affc:e2a8:4fd2]) by SJ0PR10MB4542.namprd10.prod.outlook.com
 ([fe80::1aac:affc:e2a8:4fd2%4]) with mapi id 15.20.6699.020; Sun, 20 Aug 2023
 21:50:39 +0000
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
        linus.walleij@linaro.org, konrad.wilk@oracle.com,
        kirill.shutemov@linux.intel.com, kernel@xen0n.name,
        keescook@chromium.org, juerg.haefliger@canonical.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com,
        hca@linux.ibm.com, hbathini@linux.ibm.com,
        gregkh@linuxfoundation.org, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
        frederic@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
        catalin.marinas@arm.com, bp@alien8.de, borntraeger@linux.ibm.com,
        boris.ostrovsky@oracle.com, bhe@redhat.com, arnd@arndb.de,
        ardb@kernel.org, aou@eecs.berkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com
Subject: [PATCH] x86/crash: correct unused function build error
Date:   Sun, 20 Aug 2023 17:50:31 -0400
Message-Id: <20230820215031.3539-1-eric.devolder@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To SJ0PR10MB4542.namprd10.prod.outlook.com
 (2603:10b6:a03:2da::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4542:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: cf3d9701-5b35-4dd1-9340-08dba1c77dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6s2wHRjrdxBXir+uwSn4SNE9nzTqUWEmpkYBrUP7NecFMgywk6qZ75oYxFv5VG+OhEK/lGZ0+ZH8HlOGis4fleIToUqigJjyVwUyN6MbwCjyGFAEABij16NuFtl+NlYFzOLnQKi0dYdLppLPqfQmh6AldRSIhBIVj3Q/P1ulkMpZujzVnLvTttM5hR8vZLgcvOOinU6SDYZUAOQEyIJbEUp5Zip7Ntho19VEWPhS6vQAJf83Cz1yNqGwtiWrMItGKbgYJk5tk0UyISOdNQg0Ofg+2A7e/l0GwZmRHnbBuLWWItt21JCfI0lpOrArVrOa9HUzE1MkTPDx9G2vZdHcrB0VdmGCk+w/pv8Rhbe+IZg0qCfTdugg4Zb3uL1jnmX92oVXdCM+z6r0D79+CHQ3tT9YWmdjL/ihKCLAft7iCThh2qEWqepTu9rIyBSdFvHVcJAfukl5/X9H+So88YEY30Lz8FxONwp9Q6Nb+aINe74onBZhk1e5ez4cacw14BI8ryPAyuILWDqKRaVMNT7cg1z+BiszoFG1+9QIMXyC0/N+SoCas1bhC4DBsoF4rS/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4542.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(39850400004)(346002)(366004)(186009)(1800799009)(451199024)(66476007)(66556008)(66946007)(316002)(6512007)(8676002)(8936002)(2616005)(4326008)(1076003)(41300700001)(36756003)(478600001)(6666004)(38100700002)(6506007)(6486002)(4744005)(2906002)(7416002)(7406005)(7366002)(83380400001)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MUQG4+izX+V2HVvaeAV/rIrRXCTt+DZ0Shj8kBSKj3K3HQSWNC2tSpIFv9sd?=
 =?us-ascii?Q?lkNIeBlpLahlW1uT4UxbcFoyxEianc4mHDMMEulhCow1mpUYzr5/hiuPW5kX?=
 =?us-ascii?Q?Yd5rR1RGVg45SBs4KeGrCzZp6Dw5k4hk6DrikO/7XSHdRp3oaaGT70rMa4M3?=
 =?us-ascii?Q?4LGqEXvJbN4eViAais4oLahEBExSHJC+fUd2LPhy8DxOGaF+FSwFOOqV6CJi?=
 =?us-ascii?Q?oOTbfzwYX1SuqhwCawZE2WSpfUGWez5ijw8h3goihXG96WatKzi0bMyQ3xzr?=
 =?us-ascii?Q?7RKS3aM4Bgm3xI3P54s8ZWc9RtP/wBw6iNPqPC/y2MxWOzIv9zNf7FGHsWMp?=
 =?us-ascii?Q?DAub8jslymkI2xgyXC51jzC5Bkn6Goes/KACzZFuAL2vBegXexsBG/wL/lqp?=
 =?us-ascii?Q?bOdK1DSflzGJYQvRAH8Nv5CfXzrlTa8tb0L5GXLUyn24N/iI+e3+jhS60APg?=
 =?us-ascii?Q?TdisO90EFLNeg+YecTfCBtHgaRvjRWCuPw4YrYbH1ec9B1aI8nZgPGBCTPFv?=
 =?us-ascii?Q?LN6oozcusF12+at0WpaIFQBdJwWuFeLLT1FVsFGwHNVFUc4219J/EUw6hGyZ?=
 =?us-ascii?Q?GVDQyZJas5PecAKfigloCcpYKwWF5QHJRJuV4sb2/aHMCreeynWFUoaUZY1Q?=
 =?us-ascii?Q?05bUvaooucaLIjBDbAjhfRDe2FSJKY40+jDKOKdmq10UachK7P1btx/jngZT?=
 =?us-ascii?Q?3kBu2fASMs0ddXNkxezN31MjUSMWHiyG68W3qPgtoNf5DOw69JxbLJiv3uor?=
 =?us-ascii?Q?YwWubpF37qFdkt3w+cOgvdEsoxrE23YeTxv0jMDXYaNMC+Dl4iazJD8x+CDb?=
 =?us-ascii?Q?2g5GA7c8fg2bmRA2deNTCtDL1RO1INNvEXqZG2Wpw089co+5n69NbaqSh6xN?=
 =?us-ascii?Q?qcHe3N1fwSQVca9zboCQhJUEPRsJY29ikoQVWGVbUr2qIWyorzbRVBrdEFHl?=
 =?us-ascii?Q?wSPJO1J7HYER3GQ7XxW1eNGhyD2ry8N1VYGfzJjRCjZr607l64F2hQka2TGW?=
 =?us-ascii?Q?hnfNMwTiDbaL1OytVf1p6RQeogoT2/xEUTMT/HIf5R0DlQoHVA37F0YEn9tT?=
 =?us-ascii?Q?Q72E2nABflN0TrvszUI5XMJklmoV8sxXPxBmN9Ux25BIt2kFUsjHYeiXgQ/R?=
 =?us-ascii?Q?L5pcEfi+3DBF7czfePmwvNMnWdCw6D/BJd5zLVA7ljcDiCSfvWgCqIoERlKO?=
 =?us-ascii?Q?Y4cB893E4aF8zIvVdY5w7xY8dqxpfYHzrWisqBhp8jZzjdNVrIm95UROtKI0?=
 =?us-ascii?Q?K+Jafc9cN3onfFMMas3JLsz2lRtGxKeFKYAu7WoByUN8Bg141CWNjE+/Sj57?=
 =?us-ascii?Q?uz1sLlo54RL3onmNq3SsWeNzb2ViGZBL9/yuhZsEBK4FxW0yQBtOLI74TuSM?=
 =?us-ascii?Q?D8+HTeHGo4aHsmYHlzBUcjr0pcoVv2kRSfaJghMLTjOO6a+CnMaB6Eiley52?=
 =?us-ascii?Q?0XyWni4IB6SCmuEHLUnwwtkEugAMQJ/ph/6zFf1o3ic8BaLy13uGE4sNvauJ?=
 =?us-ascii?Q?GRCDaRbZJiXacBZqNn9yNlf90dbbyv+pNmmZY+Iu/8TN/hMIsLBatg9DV5hZ?=
 =?us-ascii?Q?Nsb03zN6N1TxZsCFW/fnor8P81a0YcLivHmCX5jYeVWn0zfbIUbHkACS019H?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?oiOWrASumhjON4/eoCoHgchHaLg1rDwGc2ACprq/Be3oAFrrq4hGkIECxW6v?=
 =?us-ascii?Q?QH9bR9CahF2y67+cpdKGX3WG4IkCKiCsmw7zSI4yVUXRs9IXLePoYpj4ezmR?=
 =?us-ascii?Q?D+ihJMVhZ02rN1xjO6wtZx1GpRiW+GRZh+NB35QVr+UuE+a0m35IMawrXmf7?=
 =?us-ascii?Q?aMaH5njGTwbDRiWxGclfwPmR6KjF9G9sdpAM+0P51mCstkGBVyxCmeOzjIgy?=
 =?us-ascii?Q?zzoqPS7gcydADhUnUrEJRczAJXH6WmIQZoZMkH8ZpHefP8VT0zpfKTbDiSPG?=
 =?us-ascii?Q?Wd5KhrX04FsIFeFzbaud7VYReftb3p4yIeTey1aonClp5QPWr4XcoDjAewus?=
 =?us-ascii?Q?vbD6MPC43GxDHHZulc/DpsQLuuIGDh0X75Y/qOyaWvptvUBs9kjxi0JYSGYm?=
 =?us-ascii?Q?2BL3DMdk3tUj4QqpARCE5RWRsj3FjnMR/9S72kG0W57he/dRyon5kkcfw5Td?=
 =?us-ascii?Q?qvNPZxSUrMNzfmmbqW43olAZWrljr6MZlRtXy2nAN+3olgclbYl3WgMlZOsl?=
 =?us-ascii?Q?pViIo2OFHMe3Guqryd2toBZD8TcZAAcdRkrRTJ68kBbtR1Arz50TFAIJoD3m?=
 =?us-ascii?Q?HGvpN1D1pkvPOd40lRQH2zcv1XX6cHc5l3BkrsV2jABBJbTiXmjNjbl8rNKH?=
 =?us-ascii?Q?faF+deD0Vct1M4BA0fCAapfo7lkarBSqbWKfRJjzLaEFpiwBOtUbJD198Njg?=
 =?us-ascii?Q?JWFy8Nnz8F6fVR6rZzGYBXtngHaq2WWt9G2g/r8VGbeTWN+I9hW5yZ6pyOI0?=
 =?us-ascii?Q?gFMsLpdUoBDjZNHWdyBrKmVWUg6ns1Zz6o/MPsphG/DZM0sDdgnfm3pJnUnH?=
 =?us-ascii?Q?IWk4Z4+GLWX6FrX9mZlaYYRLbtNnrhr6vviqdn10e4jO+AlLG+HNptGXILqC?=
 =?us-ascii?Q?2KE8cHn3fhT56HDqKd01KLovCnlun+AG3vt2K1n+JI11egvJadrbc5h+XaQQ?=
 =?us-ascii?Q?cl6/8MkYUN38RxT6FIp2pwvEtJWZqXMvwaRcigmaw0A71wUjCj+e+B4zHrZv?=
 =?us-ascii?Q?RrP2bk1TGZhkK7hi+2SnJchv3mfCDzxqCsrS07XqxDEktqq2DGjZLWLwPRSp?=
 =?us-ascii?Q?rhWcZkP16FGuT8cHYObScrqcqfWxegUWo4bmLjvzr/fhNn2br+wODGgUxlUE?=
 =?us-ascii?Q?eImAa8KorUoF9jQwbycLB8g2uE6sFF2dwv6K1qxulDcAx6WPDxCR0J/RsNyk?=
 =?us-ascii?Q?suR45BDcqYGKsqgP+Q+KGjtDFmZ1ga8iCOCfRcz8ABMQuWrcQwJdzV+nylRz?=
 =?us-ascii?Q?3Sd0l7+9uvg1ZUH3HnP7BdFp0zGdSU3kEIAoGIKbg7+Tnl09W44sSOvAvU9r?=
 =?us-ascii?Q?4PurtpOEddi5fxHHplmGboUlF7q4zr5IRxn1OkpMPIxUrFck14iGZO4szifw?=
 =?us-ascii?Q?hLsCbLezGEYhIVX+b5CN5A7G2N19dFzifNOScJJ1m3wY/8eMXgk3UvVXX6I1?=
 =?us-ascii?Q?APeijkxyc81nFhpZliA+xM90lFYX06IJAItPTcA1baxraOO2tig+xfvPDHnO?=
 =?us-ascii?Q?D+oSn70IipdDeSgXON3xC9edwp0gD/J/JFfKyXTyTlmiFLMG5DLur/t+M4Ue?=
 =?us-ascii?Q?YIrw9UCf/H4mMPLOs+UlmXJRVAui8tPcK0eK9/p/jTDZnyvTjC1qvr7+9I/O?=
 =?us-ascii?Q?v9B1wwPax0E+aZxseIsfmFpAl88cbC00jv5Xia3HAXheBrd0d6xpp8tsyBy8?=
 =?us-ascii?Q?6A2V/vMgExdY7XdYLkrfq1nW3Qh21IcWZpuMURcwhDXnR/PVMAVPcEjoiza3?=
 =?us-ascii?Q?qk0OJvHPv3B2aJi//NjoKayeLvbM/UCO5qSjfBjAXAiFjpC37p9WuPGzsLDU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-1: GlVPDy0/tGyUOSGDtIQbYiiV3YpfbYuF8ckgysk0yQzfIDEs7pUDWFxND6Y0JaFhHlFeTc1zzdUbsyUh+7srZnwPE0xhtmzRU1bmhaZTE7N1ZN0c+QvlPM1gHMeJE4Po/guFbVoLL1No6+LjN5IZQj/bcG+NOVCc8ZQQhgR0C0wy8lGrvrR7XJnensYH7pUpXCsCTAdZhI9e4PUlqQCFiRXNHdrSJZ4sLT8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3d9701-5b35-4dd1-9340-08dba1c77dee
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4542.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2023 21:50:39.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UJInQ8GhonsVuKz/BYWTpSOxLivdarU8uqbEEtbnvqtTHl9sjuiErCHFsSd27kTX4SH9+4INEhwWNOKbp2y++14H8ytffAZWbUgN7P7I7r8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-20_15,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308200212
X-Proofpoint-GUID: 9Gj7_sPJuqncGF48i17LHz39FxHNAQ33
X-Proofpoint-ORIG-GUID: 9Gj7_sPJuqncGF48i17LHz39FxHNAQ33
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

In certain config scenarios, an unused-function build error occurs
relating to prepare_elf_headers(). Correct the ifdef guarding these
functions to eliminate the build error.

Suggested-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Eric DeVolder <eric.devolder@oracle.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
---
 arch/x86/kernel/crash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 86d2ca80b9b2..587c7743fd21 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -158,7 +158,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
 
-#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_DUMP)
+#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_HOTPLUG)
 static int get_nr_ram_ranges_callback(struct resource *res, void *arg)
 {
 	unsigned int *nr_ranges = arg;
-- 
2.31.1

